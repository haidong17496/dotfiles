use iced::Color;

// --- WINDOW SETTINGS ---
// Increased to allow the notification list to expand downwards without clipping.
// The actual visible area is determined by the input region logic, so this is safe.
pub const WINDOW_WIDTH: i32 = 400;
pub const WINDOW_HEIGHT: i32 = 600; 

// --- SIZES ---
pub mod size {
    pub const DASHBOARD_HEIGHT: f32 = 38.0;
    pub const MUSIC_HEIGHT: f32 = 120.0;
    pub const NOTIF_HEIGHT: f32 = 90.0;
    pub const NOTIF_CENTER_HEIGHT: f32 = 320.0; // New: Expanded list height
    
    pub const OSD_HEIGHT: f32 = 40.0; 
    pub const OSD_WIDTH: f32 = 250.0; 

    pub const MIN_WIDTH: f32 = 100.0;
    pub const MAX_WIDTH: f32 = 360.0;
    pub const MUSIC_BASE_WIDTH: f32 = 205.0; 
}

pub mod text {
    pub const CHAR_PIXEL_WIDTH: f32 = 9.0;
}

// --- COLORS ---
pub const BG: Color = Color::BLACK;
pub const WHITE: Color = Color::WHITE;
pub const MUTED: Color = Color::from_rgb(0.55, 0.55, 0.57);
pub const ACCENT: Color = Color::from_rgb(0.35, 0.35, 0.35);

pub const NOTIF_DEFAULT: Color = Color::from_rgb(1.0, 0.27, 0.22);
pub const NOTIF_BROWSER: Color = Color::from_rgb(1.0, 0.58, 0.0);
pub const NOTIF_CHAT: Color = Color::from_rgb(0.34, 0.39, 0.95);
pub const NOTIF_MUSIC: Color = Color::from_rgb(0.11, 0.72, 0.33);
pub const NOTIF_TERM: Color = Color::from_rgb(0.31, 0.31, 0.31);

// --- FONTS ---
pub const FONT_CLOCK: u16 = 16;
pub const FONT_TITLE: u16 = 14; 
pub const FONT_SUBTITLE: u16 = 12;
pub const FONT_WS: u16 = 10;
