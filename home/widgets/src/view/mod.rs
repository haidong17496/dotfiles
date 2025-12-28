pub mod dashboard;
pub mod music;
pub mod notification;
pub mod osd; // Ensure osd module exists

use iced::widget::{button, container};
use iced::{Background, Color, Element, Length, Padding, Shadow, Vector};
use iced::alignment::{Horizontal, Vertical};

use crate::island::{DynamicIsland, IslandMode, Message};
use crate::config;

pub fn root<'a>(app: &'a DynamicIsland) -> Element<'a, Message> {
    let content: Element<Message> = match app.mode {
        IslandMode::Dashboard => dashboard::view(app),
        IslandMode::Music => music::view(app),
        IslandMode::Notification => notification::view(app),
        IslandMode::Osd => osd::view(app), // <--- FIXED HERE
    };

    let current_w = app.width.current.round();
    let current_h = app.height.current.round();

    let clipped_content = container(content)
        .width(Length::Fill)
        .height(Length::Fill)
        .clip(true)
        .align_x(Horizontal::Center)
        .align_y(Vertical::Top);

    let island = button(clipped_content)
        .on_press(Message::CycleMode)
        .width(Length::Fixed(current_w))   
        .height(Length::Fixed(current_h)) 
        .style(move |_, _| button::Style {
            background: Some(Background::Color(config::BG)),
            text_color: config::WHITE,
            border: iced::border::Border {
                radius: (19.0).into(),
                width: 0.0,
                color: Color::TRANSPARENT,
            },
            shadow: Shadow {
                color: Color::from_rgba(0.0, 0.0, 0.0, 0.5),
                offset: Vector::new(0.0, 4.0),
                blur_radius: 12.0,
            },
        });

    container(island)
        .width(Length::Fill)
        .height(Length::Fill)
        .padding(Padding { top: 10.0, right: 0.0, bottom: 0.0, left: 0.0, })
        .center_x(Length::Fill)
        .align_y(Vertical::Top)
        .style(|_| container::Style { background: Some(Background::Color(Color::TRANSPARENT)), ..Default::default() })
        .into()
}
