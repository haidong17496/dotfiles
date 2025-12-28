use iced::widget::canvas::{self, Canvas, Geometry, Path, Frame};
use iced::{Element, Length, Point, Size, Rectangle, Renderer};
use iced::alignment::{Horizontal, Vertical};
use iced::font::{Font, Weight}; 
use iced::mouse;

use crate::island::{DynamicIsland, Message};
use crate::config;

struct FullOsdBar {
    progress: f32, // 0.0 to 1.0
    icon: String,
    level_text: String,
}

impl canvas::Program<Message> for FullOsdBar {
    type State = ();

    fn draw(&self, _state: &Self::State, renderer: &Renderer, _theme: &iced::Theme, bounds: Rectangle, _cursor: mouse::Cursor) -> Vec<Geometry> {
        let mut frame = Frame::new(renderer, bounds.size());

        // 1. Draw Fill (White Pill)
        // FIX: Removed .max(bounds.height). Now it can be 0 width.
        let active_width = bounds.width * self.progress;
        
        // FIX: Calculate radius dynamically. 
        // If width is smaller than height, reduce radius to avoid drawing artifacts.
        let radius = if active_width < bounds.height {
            active_width / 2.0
        } else {
            bounds.height / 2.0
        };

        if active_width > 0.5 { // Only draw if visible
            let fill_path = Path::rounded_rectangle(
                Point::ORIGIN,
                Size::new(active_width, bounds.height),
                radius.into()
            );
            frame.fill(&fill_path, config::WHITE);
        }

        // 2. Draw Icon (Left Side)
        // Threshold: 12% progress (~30px width)
        let icon_color = if self.progress > 0.12 { config::BG } else { config::WHITE };
        
        let icon_text = canvas::Text {
            content: self.icon.clone(),
            position: Point::new(25.0, bounds.height / 2.0),
            color: icon_color,
            font: Font::with_name("JetBrainsMono Nerd Font"),
            size: 20.0.into(),
            horizontal_alignment: Horizontal::Center,
            vertical_alignment: Vertical::Center,
            ..canvas::Text::default()
        };
        frame.fill_text(icon_text);

        // 3. Draw Percentage (Right Side)
        // Threshold: 88% progress
        let text_color = if self.progress > 0.88 { config::BG } else { config::WHITE };

        let percent_text = canvas::Text {
            content: self.level_text.clone(),
            position: Point::new(bounds.width - 25.0, bounds.height / 2.0),
            color: text_color,
            font: Font { weight: Weight::Bold, ..Default::default() },
            size: 14.0.into(),
            horizontal_alignment: Horizontal::Center,
            vertical_alignment: Vertical::Center,
            ..canvas::Text::default()
        };
        frame.fill_text(percent_text);

        vec![frame.into_geometry()]
    }
    
    fn mouse_interaction(&self, _state: &Self::State, _bounds: Rectangle, _cursor: mouse::Cursor) -> mouse::Interaction {
        mouse::Interaction::default()
    }
}

pub fn view<'a>(app: &'a DynamicIsland) -> Element<'a, Message> {
    let icon_text = if app.osd_icon.is_empty() { "\u{f028}" } else { &app.osd_icon };
    
    // Normalize progress 0-100 -> 0.0-1.0
    let progress_val = (app.osd_progress.current / 100.0).max(0.0).min(1.0);
    
    let level_str = format!("{}%", app.osd_progress.current.round() as i32);

    Canvas::new(FullOsdBar { 
        progress: progress_val,
        icon: icon_text.to_string(),
        level_text: level_str
    })
    .width(Length::Fixed(config::size::OSD_WIDTH))
    .height(Length::Fixed(config::size::OSD_HEIGHT))
    .into()
}
