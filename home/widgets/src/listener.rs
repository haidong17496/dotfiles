use hyprland::event_listener::AsyncEventListener;
use hyprland::shared::WorkspaceType;
use hyprland::data::{Workspaces, Monitors};
use hyprland::prelude::*;
use iced::futures::SinkExt;
use tokio::io::{AsyncBufReadExt, BufReader};
use tokio::process::Command;
use regex::Regex;
use std::time::Duration;

use crate::island::Message;

async fn fetch_and_sort() -> Option<(Vec<i32>, Vec<i32>)> {
    let mut monitors = Monitors::get_async().await.ok()?.to_vec();
    monitors.sort_by(|a, b| a.x.cmp(&b.x));

    let left_name = monitors.get(0).map(|m| m.name.clone());
    let right_name = monitors.get(1).map(|m| m.name.clone());
    let workspaces = Workspaces::get_async().await.ok()?;

    let mut left = vec![];
    let mut right = vec![];

    for ws in workspaces {
        if Some(&ws.monitor) == left_name.as_ref() { left.push(ws.id); }
        else if Some(&ws.monitor) == right_name.as_ref() { right.push(ws.id); }
        else if right_name.is_none() { left.push(ws.id); } 
    }
    left.sort(); 
    right.sort();
    Some((left, right))
}

pub fn listen_to_hyprland() -> impl iced::futures::Stream<Item = Message> {
    iced::stream::channel(100, |mut output| async move {
        if let Some((l, r)) = fetch_and_sort().await { 
            let _ = output.send(Message::WorkspaceDataUpdated { left: l, right: r }).await; 
        }
        if let Ok(active) = hyprland::data::Workspace::get_active_async().await { 
            let _ = output.send(Message::ActiveWorkspaceChanged(active.id)).await; 
        }

        let mut listener = AsyncEventListener::new();
        let s1 = output.clone(); 
        let s2 = output.clone(); 
        let s3 = output.clone(); 

        listener.add_workspace_changed_handler(move |event| {
            let mut sender = s1.clone();
            Box::pin(async move {
                let id = match event.name {
                    WorkspaceType::Regular(i) => i.parse().unwrap_or(1),
                    WorkspaceType::Special(_) => -99,
                };
                let _ = sender.send(Message::ActiveWorkspaceChanged(id)).await;
            })
        });

        listener.add_active_monitor_changed_handler(move |event| {
            let mut sender = s2.clone();
            Box::pin(async move {
                if let Some(ws_type) = event.workspace_name {
                     let id = match ws_type {
                        WorkspaceType::Regular(i) => i.parse().unwrap_or(1),
                        WorkspaceType::Special(_) => -99,
                    };
                    let _ = sender.send(Message::ActiveWorkspaceChanged(id)).await;
                }
            })
        });

        let refresh = move |mut sender: iced::futures::channel::mpsc::Sender<Message>| {
            Box::pin(async move {
                if let Some((l, r)) = fetch_and_sort().await {
                    let _ = sender.send(Message::WorkspaceDataUpdated { left: l, right: r }).await;
                }
            })
        };
        
        let r1 = s3.clone(); listener.add_window_opened_handler(move |_| refresh(r1.clone()));
        let r2 = s3.clone(); listener.add_window_closed_handler(move |_| refresh(r2.clone()));
        let r3 = s3.clone(); listener.add_workspace_added_handler(move |_| refresh(r3.clone()));
        let r4 = s3.clone(); listener.add_workspace_deleted_handler(move |_| refresh(r4.clone()));
        let r5 = s3.clone(); listener.add_monitor_added_handler(move |_| refresh(r5.clone()));
        let r6 = s3.clone(); listener.add_monitor_removed_handler(move |_| refresh(r6.clone()));
        
        listener.start_listener_async().await.ok();
    })
}

// --- VOLUME LISTENER (Fixed: Debounce logic) ---
pub fn listen_to_volume() -> impl iced::futures::Stream<Item = Message> {
    iced::stream::channel(10, |mut output| async move {
        // State tracking to prevent OSD showing on Play/Pause
        let mut last_known_level = -1.0;
        let mut last_known_muted = false;

        let re_vol = Regex::new(r"Volume:\s+(\d+\.\d+)").unwrap();

        // Helper function to fetch and parse current volume
        async fn get_wpctl_status(re: &Regex) -> Option<(f32, bool)> {
            let wp_output = Command::new("wpctl")
                .args(["get-volume", "@DEFAULT_AUDIO_SINK@"])
                .output()
                .await
                .ok()?;
            
            let out_str = String::from_utf8_lossy(&wp_output.stdout);
            
            // Output format examples:
            // "Volume: 0.40"
            // "Volume: 0.40 [MUTED]"
            
            if let Some(caps) = re.captures(&out_str) {
                if let Some(m) = caps.get(1) {
                    if let Ok(vol_float) = m.as_str().parse::<f32>() {
                        let level = vol_float.max(0.0).min(1.0);
                        let is_muted = out_str.contains("MUTED");
                        return Some((level, is_muted));
                    }
                }
            }
            None
        }

        // 1. Initial Fetch (Set baseline so we don't flash on startup/first action)
        if let Some((lvl, muted)) = get_wpctl_status(&re_vol).await {
            last_known_level = lvl;
            last_known_muted = muted;
        }

        // 2. Start Listener
        let mut child = match Command::new("pactl")
            .arg("subscribe")
            .stdout(std::process::Stdio::piped())
            .spawn() 
        {
            Ok(c) => c,
            Err(e) => {
                println!("Error spawning pactl: {}", e);
                return;
            }
        };

        let stdout = child.stdout.take().expect("Failed to open stdout");
        let mut reader = BufReader::new(stdout).lines();

        while let Ok(Some(line)) = reader.next_line().await {
            // "Event 'change' on sink #49"
            if line.contains("sink") && line.contains("change") {
                
                // Check actual volume
                if let Some((level, is_muted)) = get_wpctl_status(&re_vol).await {
                    
                    // --- CRITICAL FIX ---
                    // Only send update if volume/mute CHANGED
                    let level_changed = (level - last_known_level).abs() > 0.001;
                    let mute_changed = is_muted != last_known_muted;

                    if level_changed || mute_changed {
                        last_known_level = level;
                        last_known_muted = is_muted;

                        let icon = if is_muted || level <= 0.0 { "\u{f026}" } // Mute
                                   else if level < 0.5 { "\u{f027}" } // Low
                                   else { "\u{f028}" }; // High
                        
                        let _ = output.send(Message::OsdUpdate { 
                            icon: icon.to_string(), 
                            level 
                        }).await;
                    }
                }
            }
        }
    })
}

// --- BRIGHTNESS LISTENER ---
pub fn listen_to_brightness() -> impl iced::futures::Stream<Item = Message> {
    iced::stream::channel(10, |mut output| async move {
        let mut last_brightness = -1.0;

        loop {
            let current = Command::new("brightnessctl").arg("g").output().await;
            let max = Command::new("brightnessctl").arg("m").output().await;

            if let (Ok(c), Ok(m)) = (current, max) {
                let c_str = String::from_utf8_lossy(&c.stdout).trim().to_string();
                let m_str = String::from_utf8_lossy(&m.stdout).trim().to_string();

                if let (Ok(c_val), Ok(m_val)) = (c_str.parse::<f32>(), m_str.parse::<f32>()) {
                    let level = (c_val / m_val).max(0.0).min(1.0);

                    if (level - last_brightness).abs() > 0.01 {
                        if last_brightness != -1.0 { 
                            let icon = "\u{f185}"; 
                            let _ = output.send(Message::OsdUpdate { 
                                icon: icon.to_string(), 
                                level 
                            }).await;
                        }
                        last_brightness = level;
                    }
                }
            }
            tokio::time::sleep(Duration::from_millis(300)).await;
        }
    })
}
