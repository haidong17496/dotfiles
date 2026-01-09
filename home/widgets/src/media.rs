use mpris::{PlayerFinder, PlaybackStatus, FindingError, TrackID};
use std::time::Duration;

#[derive(Debug, Clone)]
pub struct MediaInfo {
    pub title: String,
    pub artist: String,
    pub is_playing: bool,
    pub length: Option<Duration>,
    pub position: Option<Duration>,
    #[allow(dead_code)]
    pub track_id: Option<TrackID>,
}

impl Default for MediaInfo {
    fn default() -> Self {
        Self {
            title: "No Media".to_string(),
            artist: "".to_string(),
            is_playing: false,
            length: None,
            position: None,
            track_id: None,
        }
    }
}

fn player_to_media_info(player: &mpris::Player) -> Option<MediaInfo> {
    let metadata = player.get_metadata().ok()?;
    let status = player.get_playback_status().ok()?;

    Some(MediaInfo {
        title: metadata.title().unwrap_or("Unknown").to_string(),
        artist: metadata.artists().map(|a| a.join(", ")).unwrap_or_default(),
        is_playing: status == PlaybackStatus::Playing,
        length: metadata.length(),
        position: player.get_position().ok(),
        track_id: metadata.track_id(),
    })
}

// Accepts &PlayerFinder to reuse the connection
pub fn get_active_media(finder: &PlayerFinder) -> Option<MediaInfo> {
    let players = finder.find_all().ok()?;

    // 1. Priority: Playing + Valid Title + NOT "Firefox"
    if let Some(player) = players.iter().find(|p| {
        let is_playing = matches!(p.get_playback_status(), Ok(PlaybackStatus::Playing));
        let title = p.get_metadata().ok().and_then(|m| m.title().map(|t| t.to_string())).unwrap_or_default();

        let valid_title = !title.is_empty() && title != "Unknown" && title != "Firefox" && title != "Mozilla Firefox";

        is_playing && valid_title
    }) {
        return player_to_media_info(player);
    }

    // 2. Fallback: Just Playing
    if let Some(player) = players.iter().find(|p| matches!(p.get_playback_status(), Ok(PlaybackStatus::Playing))) {
        return player_to_media_info(player);
    }

    // 3. Fallback: Paused
    if let Some(player) = players.iter().find(|p| matches!(p.get_playback_status(), Ok(PlaybackStatus::Paused))) {
        return player_to_media_info(player);
    }

    None
}

// --- COMMANDS ---
pub fn send_command(control: MediaControl) {
    let finder = match PlayerFinder::new() { Ok(f) => f, Err(_) => return, };
    if let Some(player) = get_best_player_for_command(&finder) {
        match control {
            MediaControl::PlayPause => { let _ = player.play_pause(); },
            MediaControl::Next => { let _ = player.next(); },
            MediaControl::Previous => { let _ = player.previous(); },
        }
    }
}

pub fn seek(position: Duration) {
    let finder = match PlayerFinder::new() { Ok(f) => f, Err(_) => return, };
    if let Some(player) = get_best_player_for_command(&finder) {
        if let Ok(metadata) = player.get_metadata() {
            if let Some(track_id) = metadata.track_id() {
                let _ = player.set_position(track_id, &position);
            }
        }
    }
}

// FIXED: Returns owned Player by removing it from the Vec
fn get_best_player_for_command(finder: &PlayerFinder) -> Option<mpris::Player> {
    let mut players = finder.find_all().ok()?;

    // 1. Find index of playing player
    if let Some(index) = players.iter().position(|p| matches!(p.get_playback_status(), Ok(PlaybackStatus::Playing))) {
        return Some(players.remove(index));
    }

    // 2. Find index of paused player
    if let Some(index) = players.iter().position(|p| matches!(p.get_playback_status(), Ok(PlaybackStatus::Paused))) {
        return Some(players.remove(index));
    }

    // 3. Fallback: Take the first one if any exist
    players.into_iter().next()
}

#[derive(Debug, Clone, Copy)]
pub enum MediaControl { PlayPause, Next, Previous }
