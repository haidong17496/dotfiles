use iced::{time, Element, Subscription, Task};
use iced::widget::canvas;
use std::time::{Duration, Instant};
use chrono::Local;
use iced_layershell::actions::{LayershellCustomActions, ActionCallback};
use iced::futures::SinkExt;
use iced::event::{self, Event};
use iced::mouse;

use crate::spring::Spring;
use crate::media::{self, MediaInfo};
use crate::notification::{self, NotificationData};
use crate::listener;
use crate::view;
use crate::config;

#[derive(Debug, Clone, PartialEq)]
pub enum IslandMode {
    Dashboard,
    Music,
    Notification,
    NotificationCenter,
    Osd,
}

#[derive(Debug, Clone)]
pub enum Message {
    Tick(()),
    ClockTick(()),
    CycleMode,

    MediaTick(()),
    MediaUpdate(Option<MediaInfo>),
    TogglePlayPause,
    SkipNext,
    SkipPrevious,
    Seek(f32),
    ToggleMute,

    ActiveWorkspaceChanged(i32),
    WorkspaceDataUpdated { left: Vec<i32>, right: Vec<i32> },
    UpdateInputRegion { width: f32, height: f32 },

    NotificationReceived(NotificationData),
    ClearAllNotifications,

    SwitchToWorkspace(i32),
    OsdUpdate { icon: String, level: f32 },
    VolumeScroll(f32),
    BatteryUpdate { level: f32, is_charging: bool },
}

impl TryInto<LayershellCustomActions> for Message {
    type Error = Message;
    fn try_into(self) -> Result<LayershellCustomActions, Self::Error> {
        match self {
            Message::UpdateInputRegion { width, height } => {
                let w = width.round() as i32;
                let h = height.round() as i32;
                let x = (config::WINDOW_WIDTH - w) / 2;
                Ok(LayershellCustomActions::SetInputRegion(
                    ActionCallback::new(move |region| { region.add(x, 0, w, h); })
                ))
            }
            _ => Err(self)
        }
    }
}

pub struct DynamicIsland {
    pub mode: IslandMode,
    pub current_time: String,
    pub active_workspace: i32,
    pub left_workspaces: Vec<i32>,
    pub right_workspaces: Vec<i32>,
    pub media_info: MediaInfo,
    pub notification_info: Option<NotificationData>,
    pub notification_history: Vec<NotificationData>,

    pub last_known_playing: bool,
    pub auto_close_timer: Option<Instant>,
    pub manually_opened: bool,
    pub width: Spring,
    pub height: Spring,
    pub is_animating: bool,
    pub marquee_offset: f32,
    pub music_progress: Spring,
    pub osd_progress: Spring,
    pub last_sent_size: (i32, i32),
    pub last_seek_time: Option<Instant>,
    pub osd_icon: String,
    pub pre_osd_mode: Option<IslandMode>,

    pub battery_level: f32,
    pub is_charging: bool,

    pub marquee_cache: canvas::Cache,
    pub progress_cache: canvas::Cache,
    pub osd_cache: canvas::Cache,
}

impl DynamicIsland {
    pub fn new() -> (Self, Task<Message>) {
        (
            Self {
                mode: IslandMode::Dashboard,
                current_time: Local::now().format("%H:%M").to_string(),
                active_workspace: 1,
                left_workspaces: vec![1],
                right_workspaces: vec![],
                media_info: MediaInfo::default(),
                notification_info: None,
                notification_history: Vec::new(),
                last_known_playing: false,
                auto_close_timer: None,
                manually_opened: false,
                width: Spring::new(config::size::MIN_WIDTH),
                height: Spring::new(config::size::DASHBOARD_HEIGHT),
                is_animating: true,
                marquee_offset: 0.0,
                music_progress: Spring::new(0.0),
                osd_progress: Spring::new(0.0),
                last_sent_size: (0, 0),
                last_seek_time: None,
                osd_icon: "\u{f028}".to_string(),
                pre_osd_mode: None,
                battery_level: 100.0,
                is_charging: false,
                marquee_cache: canvas::Cache::default(),
                progress_cache: canvas::Cache::default(),
                osd_cache: canvas::Cache::default(),
            },
            Task::none()
        )
    }

    pub fn update(&mut self, message: Message) -> Task<Message> {
        match message {
            Message::ClockTick(_) => {
                self.current_time = Local::now().format("%H:%M").to_string();
                Task::none()
            }
            Message::Tick(_) => self.handle_tick(),
            Message::CycleMode => self.handle_cycle_mode(),
            Message::MediaTick(_) => Task::perform(async {
                tokio::task::spawn_blocking(|| media::get_active_media()).await.unwrap_or(None)
            }, Message::MediaUpdate),
            Message::MediaUpdate(info) => {
                let new_info = info.clone().unwrap_or(MediaInfo::default());
                if new_info.title != self.media_info.title {
                    self.marquee_offset = 0.0;
                    self.marquee_cache.clear();
                }
                self.handle_media_update(info)
            },
            Message::TogglePlayPause => self.handle_media_control(media::MediaControl::PlayPause),
            Message::SkipNext => self.handle_media_control(media::MediaControl::Next),
            Message::SkipPrevious => self.handle_media_control(media::MediaControl::Previous),
            Message::Seek(percent) => self.handle_seek(percent),
            Message::ToggleMute => {
                Task::perform(async {
                    tokio::process::Command::new("wpctl").args(["set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]).output().await.ok();
                }, |_| Message::Tick(()))
            },

            Message::NotificationReceived(data) => {
                self.notification_history.insert(0, data.clone());
                if self.notification_history.len() > 10 {
                    self.notification_history.pop();
                }
                self.handle_notification(data)
            },

            Message::ClearAllNotifications => {
                self.notification_history.clear();
                self.close_to_dashboard();
                Task::none()
            },

            Message::WorkspaceDataUpdated { left, right } => {
                self.left_workspaces = left;
                self.right_workspaces = right;
                if self.mode == IslandMode::Dashboard { self.is_animating = true; }
                Task::none()
            },
            Message::ActiveWorkspaceChanged(id) => { self.active_workspace = id; Task::none() },
            Message::UpdateInputRegion { .. } => Task::none(),
            Message::SwitchToWorkspace(id) => self.handle_switch_to_workspace(id),
            Message::OsdUpdate { icon, level } => {
                self.osd_cache.clear();
                self.handle_osd_update(icon, level)
            },
            Message::VolumeScroll(delta) => self.handle_volume_scroll(delta),
            Message::BatteryUpdate { level, is_charging } => {
                self.battery_level = level;
                self.is_charging = is_charging;
                Task::none()
            }
        }
    }

    pub fn view<'a>(&'a self) -> Element<'a, Message> {
        view::root(self)
    }

    pub fn subscription(&self) -> Subscription<Message> {
        let mut subs = vec![];

        let should_tick_for_media = self.mode == IslandMode::Music && self.media_info.is_playing;

        // Only tick if animations are running OR auto-close timer is active OR media is playing
        if self.is_animating || self.auto_close_timer.is_some() || should_tick_for_media {
            subs.push(time::every(Duration::from_millis(16)).map(|_| Message::Tick(())));
        }

        subs.push(time::every(Duration::from_secs(1)).map(|_| Message::ClockTick(())));

        subs.push(Subscription::run(listener::listen_to_media));
        subs.push(Subscription::run(listener::listen_to_hyprland));
        subs.push(Subscription::run(|| {
            iced::stream::channel(10, |mut output| async move {
                let mut rx = notification::listen().await;
                while let Some(data) = rx.recv().await {
                    let _ = output.send(Message::NotificationReceived(data)).await;
                }
            })
        }));
        subs.push(Subscription::run(listener::listen_to_volume));
        subs.push(Subscription::run(listener::listen_to_brightness));
        subs.push(Subscription::run(listener::listen_to_battery));

        if self.mode != IslandMode::NotificationCenter {
            subs.push(event::listen_with(|evt, _status, _window_id| {
                if let Event::Mouse(mouse::Event::WheelScrolled { delta, .. }) = evt {
                    match delta {
                        mouse::ScrollDelta::Lines { y, .. } => Some(Message::VolumeScroll(y)),
                        mouse::ScrollDelta::Pixels { y, .. } => Some(Message::VolumeScroll(y)),
                    }
                } else {
                    None
                }
            }));
        }

        Subscription::batch(subs)
    }

    fn handle_tick(&mut self) -> Task<Message> {
        let dt = 0.016;

        if let Some(timer) = self.auto_close_timer {
            if !self.manually_opened && Instant::now() > timer {
                self.handle_auto_close();
            }
        }

        self.animate_layout_sequence();

        // --- OPTIMIZATION START ---
        // Always animate dimensions
        let running_width = self.width.update(dt);
        let running_height = self.height.update(dt);

        // Conditionally animate contents
        let running_music = if self.mode == IslandMode::Music {
            self.music_progress.update(dt)
        } else {
            false
        };

        let running_osd = if self.mode == IslandMode::Osd {
            self.osd_progress.update(dt)
        } else {
            false
        };
        // --- OPTIMIZATION END ---

        if self.mode == IslandMode::Music {
            let prev_offset = self.marquee_offset;
            if self.width.target >= config::size::MAX_WIDTH {
                let container_width = self.width.current - 120.0;
                let text_width = (self.media_info.title.chars().count() as f32 * config::text::CHAR_PIXEL_WIDTH) + 20.0;
                if text_width > container_width {
                    self.marquee_offset -= 30.0 * dt;
                    if self.marquee_offset < -text_width { self.marquee_offset = container_width; }
                } else { self.marquee_offset = 0.0; }
            } else { self.marquee_offset = 0.0; }

            if (self.marquee_offset - prev_offset).abs() > 0.001 { self.marquee_cache.clear(); }

            if self.media_info.is_playing {
                self.progress_cache.clear();
                if let Some(length) = self.media_info.length {
                    if length > Duration::from_secs(0) {
                        let increment = 100.0 / length.as_secs_f32() * dt;
                        self.music_progress.set_target(self.music_progress.target + increment);
                    }
                }
            }
        }

        if self.mode == IslandMode::Osd { self.osd_cache.clear(); }

        let springs_settled = !running_width && !running_height && !running_music && !running_osd;
        let animation_required = self.mode == IslandMode::Music && self.media_info.is_playing;

        // If springs are settled and no music is playing, this becomes FALSE, stopping the tick.
        self.is_animating = !springs_settled || animation_required;

        let current_w = self.width.current.round() as i32;
        let current_h = self.height.current.round() as i32;
        if (current_w - self.last_sent_size.0).abs() > 1 || (current_h - self.last_sent_size.1).abs() > 1 {
            self.last_sent_size = (current_w, current_h);
            return Task::done(Message::UpdateInputRegion { width: self.width.current, height: self.height.current });
        }

        Task::none()
    }

    fn animate_layout_sequence(&mut self) {
        match self.mode {
            IslandMode::Music => {
                let width_threshold = self.width.target * 0.9;
                if self.width.current > width_threshold && self.height.target != config::size::MUSIC_HEIGHT {
                    self.height.set_target(config::size::MUSIC_HEIGHT);
                }
            },
            IslandMode::Notification => {
                if self.width.current > 200.0 && self.height.target != config::size::NOTIF_HEIGHT {
                    self.height.set_target(config::size::NOTIF_HEIGHT);
                }
            },
            IslandMode::NotificationCenter => {
                if self.height.target != config::size::NOTIF_CENTER_HEIGHT {
                    self.height.set_target(config::size::NOTIF_CENTER_HEIGHT);
                }
                if self.width.target != config::size::MAX_WIDTH {
                    self.width.set_target(config::size::MAX_WIDTH);
                }
            },
            IslandMode::Osd => {
                if self.width.current > 150.0 && self.height.target != config::size::OSD_HEIGHT {
                    self.height.set_target(config::size::OSD_HEIGHT);
                }
            },
            IslandMode::Dashboard => {
                if self.height.target != config::size::DASHBOARD_HEIGHT {
                     self.height.set_target(config::size::DASHBOARD_HEIGHT);
                }

                if self.height.current < 50.0 {
                    let left_w = self.left_workspaces.len() as f32 * 22.0;
                    let right_w = self.right_workspaces.len() as f32 * 22.0;

                    let base_elements = 45.0 + 55.0 + 40.0 + 60.0;
                    let extra_w = if !self.notification_history.is_empty() { 20.0 + 15.0 } else { 0.0 };

                    let target_w = (left_w + right_w + base_elements + extra_w).max(config::size::MIN_WIDTH);

                    self.width.set_target(target_w);
                }
            }
        }
    }

    fn handle_cycle_mode(&mut self) -> Task<Message> {
        match self.mode {
            IslandMode::Osd | IslandMode::Notification => { self.handle_auto_close(); },

            IslandMode::Music => { self.close_to_dashboard(); },

            IslandMode::NotificationCenter => {
                self.mode = IslandMode::Music;
                self.height.set_target(config::size::MUSIC_HEIGHT);

                let text_len = self.media_info.title.chars().count() as f32 * config::text::CHAR_PIXEL_WIDTH;
                let target_w = (config::size::MUSIC_BASE_WIDTH + text_len).max(config::size::MIN_WIDTH).min(config::size::MAX_WIDTH);
                self.width.set_target(target_w);

                self.marquee_offset = 0.0;
                self.is_animating = true;
            },

            IslandMode::Dashboard => {
                if !self.notification_history.is_empty() {
                    self.mode = IslandMode::NotificationCenter;
                    self.manually_opened = true;
                    self.auto_close_timer = None;
                    self.is_animating = true;
                } else {
                    self.height.set_target(config::size::DASHBOARD_HEIGHT);
                    self.mode = IslandMode::Music;

                    let text_len = self.media_info.title.chars().count() as f32 * config::text::CHAR_PIXEL_WIDTH;
                    let target_w = (config::size::MUSIC_BASE_WIDTH + text_len).max(config::size::MIN_WIDTH).min(config::size::MAX_WIDTH);
                    self.width.set_target(target_w);

                    self.manually_opened = true;
                    self.auto_close_timer = None;
                    self.marquee_offset = 0.0;
                    self.is_animating = true;
                }
            }
        }
        Task::none()
    }

    fn handle_media_update(&mut self, info: Option<MediaInfo>) -> Task<Message> {
        let new_info = info.unwrap_or(MediaInfo::default());
        let is_seeking_recently = self.last_seek_time.map(|t| t.elapsed() < Duration::from_millis(2000)).unwrap_or(false);
        if self.mode == IslandMode::Music {
            if !is_seeking_recently {
                if let (Some(pos), Some(len)) = (new_info.position, new_info.length) {
                    if len > Duration::from_secs(0) {
                        let percentage = (pos.as_secs_f32() / len.as_secs_f32()) * 100.0;
                        self.music_progress.current = percentage.max(0.0).min(100.0);
                        self.music_progress.set_target(percentage.max(0.0).min(100.0));
                    }
                }
            }
        }
        if new_info.is_playing && !self.last_known_playing {
            if self.mode == IslandMode::Dashboard {
                self.mode = IslandMode::Music;
                self.is_animating = true;
                self.auto_close_timer = Some(Instant::now() + Duration::from_secs(4));
                self.manually_opened = false;
                self.marquee_offset = 0.0;
                self.height.set_target(config::size::DASHBOARD_HEIGHT);
            }
        }
        if self.mode == IslandMode::Music {
            let text_len = new_info.title.chars().count() as f32 * config::text::CHAR_PIXEL_WIDTH;
            let target_width = (config::size::MUSIC_BASE_WIDTH + text_len).max(config::size::MIN_WIDTH).min(config::size::MAX_WIDTH);
            self.width.set_target(target_width);
        }
        if new_info.title != self.media_info.title { self.marquee_offset = 0.0; }
        self.last_known_playing = new_info.is_playing;
        self.media_info = new_info;
        Task::none()
    }

    fn handle_notification(&mut self, data: NotificationData) -> Task<Message> {
        self.notification_info = Some(data);
        self.mode = IslandMode::Notification;
        self.width.set_target(config::size::MAX_WIDTH);
        self.height.set_target(config::size::DASHBOARD_HEIGHT);
        self.is_animating = true;
        self.auto_close_timer = Some(Instant::now() + Duration::from_secs(5));
        self.manually_opened = false;
        Task::none()
    }

    fn handle_media_control(&mut self, cmd: media::MediaControl) -> Task<Message> {
        self.manually_opened = true;
        self.auto_close_timer = None;
        Task::perform(async move {
            tokio::task::spawn_blocking(move || { media::send_command(cmd); }).await.ok();
        }, |_| Message::MediaTick(()))
    }

    fn handle_seek(&mut self, percent: f32) -> Task<Message> {
        if let Some(length) = self.media_info.length {
            let position = length.mul_f32(percent);
            self.manually_opened = true;
            self.auto_close_timer = None;
            self.last_seek_time = Some(Instant::now());
            self.music_progress.current = percent * 100.0;
            self.music_progress.set_target(percent * 100.0);
            return Task::perform(async move {
                tokio::task::spawn_blocking(move || { media::seek(position); }).await.ok();
            }, |_| Message::MediaTick(()));
        }
        Task::none()
    }

    fn handle_switch_to_workspace(&mut self, id: i32) -> Task<Message> {
        Task::perform(async move {
            tokio::task::spawn_blocking(move || {
                let _ = hyprland::dispatch::Dispatch::call(
                    hyprland::dispatch::DispatchType::Workspace(
                        hyprland::dispatch::WorkspaceIdentifierWithSpecial::Id(id)
                    )
                );
            }).await.ok();
        }, |_| Message::Tick(()))
    }

    fn handle_osd_update(&mut self, icon: String, level: f32) -> Task<Message> {
        if self.mode != IslandMode::Notification {
            let previous_mode = self.mode.clone();
            if previous_mode != IslandMode::Osd {
                self.pre_osd_mode = Some(previous_mode);
            }

            self.mode = IslandMode::Osd;
            self.osd_icon = icon;

            let target_val = level * 100.0;
            self.osd_progress.set_target(target_val);

            self.width.set_target(config::size::OSD_WIDTH);
            self.height.set_target(config::size::DASHBOARD_HEIGHT);

            self.is_animating = true;
            self.auto_close_timer = Some(Instant::now() + Duration::from_secs(2));
            self.manually_opened = false;
        }
        Task::none()
    }

    fn handle_volume_scroll(&mut self, delta: f32) -> Task<Message> {
        if delta.abs() < 0.5 { return Task::none(); }
        let is_up = delta > 0.0;
        let step = "5%";
        let arg = if is_up { format!("{}+", step) } else { format!("{}-", step) };

        Task::perform(async move {
            tokio::process::Command::new("wpctl")
                .args(["set-volume", "@DEFAULT_AUDIO_SINK@", &arg])
                .output()
                .await.ok();
        }, |_| Message::Tick(()))
    }

    fn handle_auto_close(&mut self) {
        let mut target_mode = IslandMode::Dashboard;

        if self.mode == IslandMode::Osd || self.mode == IslandMode::Notification {
            if let Some(prev_mode) = self.pre_osd_mode.take() {
                if prev_mode == IslandMode::Music && self.media_info.is_playing {
                    target_mode = IslandMode::Music;
                }
            }
        }

        match target_mode {
            IslandMode::Music => {
                self.mode = IslandMode::Music;
                self.height.set_target(config::size::DASHBOARD_HEIGHT);
            },
            _ => self.close_to_dashboard(),
        }

        self.auto_close_timer = None;
        self.is_animating = true;
    }

    fn close_to_dashboard(&mut self) {
        self.height.set_target(config::size::DASHBOARD_HEIGHT);
        self.mode = IslandMode::Dashboard;
        self.auto_close_timer = None;
        self.manually_opened = false;
        self.is_animating = true;
        self.pre_osd_mode = None;
    }
}
