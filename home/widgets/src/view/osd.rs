use iced::widget::canvas::{self, Canvas, Geometry, Path};
use iced::{Element, Length, Point, Size, Rectangle, Renderer};
use iced::alignment::{Horizontal, Vertical};
use iced::font::{Font, Weight}; 
use iced::mouse;

use crate::island::{DynamicIsland, Message};
use crate::config;

struct FullOsdBar<'a> {
    progress: f32, // 0.0 to 1.0
    icon: String,
    level_text: String,
    cache: &'a canvas::Cache,
}

impl<'a> canvas::Program<Message> for FullOsdBar<'a> {
    type State = ();

    fn draw(&self, _state: &Self::State, renderer: &Renderer, _theme: &iced::Theme, bounds: Rectangle, _cursor: mouse::Cursor) -> Vec<Geometry> {
        let geometry = self.cache.draw(renderer, bounds.size(), |frame| {
            // 1. Draw Fill (White Pill)
            let active_width = frame.width() * self.progress;
            
            let radius = if active_width < frame.height() {
                active_width / 2.0
            } else {
                frame.height() / 2.0
            };

            if active_width > 0.5 { 
                let fill_path = Path::rounded_rectangle(
                    Point::ORIGIN,
                    Size::new(active_width, frame.height()),
                    radius.into()
                );
                frame.fill(&fill_path, config::WHITE);
            }

            // 2. Draw Icon (Color Flip)
            let icon_color = if self.progress > 0.12 { config::BG } else { config::WHITE };
            let icon_text = canvas::Text {
                content: self.icon.clone(),
                position: Point::new(25.0, frame.height() / 2.0),
                color: icon_color,
                font: Font::with_name("JetBrainsMono Nerd Font"),
                size: 20.0.into(),
                horizontal_alignment: Horizontal::Center,
                vertical_alignment: Vertical::Center,
                ..canvas::Text::default()
            };
            frame.fill_text(icon_text);

            // 3. Draw Percentage (Color Flip)
            let text_color = if self.progress > 0.88 { config::BG } else { config::WHITE };
            let percent_text = canvas::Text {
                content: self.level_text.clone(),
                position: Point::new(frame.width() - 25.0, frame.height() / 2.0),
                color: text_color,
                font: Font { weight: Weight::Bold, ..Default::default() },
                size: 14.0.into(),
                horizontal_alignment: Horizontal::Center,
                vertical_alignment: Vertical::Center,
                ..canvas::Text::default()
            };
            frame.fill_text(percent_text);
        });

        vec![geometry]
    }
    
    // --- NEW: Handle Clicks ---
    fn update(&self, _state: &mut Self::State, event: canvas::Event, bounds: Rectangle, cursor: mouse::Cursor) -> (canvas::event::Status, Option<Message>) {
        if let canvas::Event::Mouse(mouse::Event::ButtonPressed(mouse::Button::Left)) = event {
            if let Some(position) = cursor.position_in(bounds) {
                // If clicked on the left side (Icon area), Toggle Mute
                if position.x < 50.0 {
                    return (canvas::event::Status::Captured, Some(Message::ToggleMute));
                }
            }
        }
        (canvas::event::Status::Ignored, None)
    }

    // --- NEW: Change Cursor ---
    fn mouse_interaction(&self, _state: &Self::State, bounds: Rectangle, cursor: mouse::Cursor) -> mouse::Interaction {
        if let Some(position) = cursor.position_in(bounds) {
            // Show pointer hand if hovering over the icon
            if position.x < 50.0 {
                return mouse::Interaction::Pointer;
            }
        }
        mouse::Interaction::default()
    }
}

pub fn view<'a>(app: &'a DynamicIsland) -> Element<'a, Message> {
    let icon_text = if app.osd_icon.is_empty() { "\u{f028}" } else { &app.osd_icon };
    let progress_val = (app.osd_progress.current / 100.0).max(0.0).min(1.0);
    let level_str = format!("{}%", app.osd_progress.current.round() as i32);

    Canvas::new(FullOsdBar { 
        progress: progress_val,
        icon: icon_text.to_string(),
        level_text: level_str,
        cache: &app.osd_cache 
    })
    .width(Length::Fixed(config::size::OSD_WIDTH)) // Fixed Size (Stable)
    .height(Length::Fixed(config::size::OSD_HEIGHT)) // Fixed Size (Stable)
    .into()
}
