use mpris::{PlayerFinder, PlaybackStatus, FindingError, TrackID};
use std::time::Duration;

#[derive(Debug, Clone)]
pub struct MediaInfo {
    pub title: String,
    pub artist: String,
    pub is_playing: bool,
    pub length: Option<Duration>,
    pub position: Option<Duration>,

    #[allow(dead_code)] // Suppress warning: we store it but re-fetch it dynamically on seek
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

pub fn get_active_media() -> Option<MediaInfo> {
    let finder = match PlayerFinder::new() {
        Ok(f) => f,
        Err(_) => return None,
    };

    // Safety check: find_all can fail
    let players = finder.find_all().ok()?;

    // 1. Priority: Is Playing AND has a valid Title
    if let Some(player) = players.iter().find(|p| {
        let is_playing = matches!(p.get_playback_status(), Ok(PlaybackStatus::Playing));
        let has_title = p.get_metadata().ok()
            .and_then(|m| m.title().map(|t| !t.is_empty() && t != "Unknown"))
            .unwrap_or(false);
        is_playing && has_title
    }) {
        return player_to_media_info(player);
    }

    // 2. Fallback: Just Playing (even if title is missing)
    if let Some(player) = players.iter().find(|p| matches!(p.get_playback_status(), Ok(PlaybackStatus::Playing))) {
        return player_to_media_info(player);
    }

    // 3. Fallback: Paused (if nothing is playing)
    if let Some(player) = players.iter().find(|p| matches!(p.get_playback_status(), Ok(PlaybackStatus::Paused))) {
        return player_to_media_info(player);
    }

    None
}

#[derive(Debug, Clone, Copy)]
pub enum MediaControl {
    PlayPause,
    Next,
    Previous,
}

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

fn get_best_player_for_command(finder: &PlayerFinder) -> Option<mpris::Player> {
    let players = finder.find_all().ok()?;
    let find_by_identity = |identity: &str| -> Result<mpris::Player, FindingError> {
        finder.find_by_name(identity)
    };

    // Prefer playing player
    if let Some(p) = players.iter().find(|p| matches!(p.get_playback_status(), Ok(PlaybackStatus::Playing))) {
        if let Ok(player) = find_by_identity(p.identity()) { return Some(player); }
    }
    // Fallback to active
    if let Ok(p) = finder.find_active() { return Some(p); }
    // Fallback to any
    if let Some(p) = players.iter().next() {
        if let Ok(player) = find_by_identity(p.identity()) { return Some(player); }
    }
    None
}
