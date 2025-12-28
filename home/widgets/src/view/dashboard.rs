use iced::widget::{button, container, row, text};
use iced::widget::text::LineHeight;
use iced::{Background, Color, Element, Length, Shadow, Vector};
use iced::alignment::{Horizontal, Vertical};
use iced::font::{Font, Weight}; 

use crate::island::{DynamicIsland, Message};
use crate::config;

pub fn view<'a>(app: &'a DynamicIsland) -> Element<'a, Message> {
    let ws_circle = |id: i32, active_id: i32| {
        let is_active = id == active_id;
        
        button(
            text(id.to_string())
                .size(config::FONT_WS)
                .font(Font { weight: Weight::Bold, ..Default::default() })
                .color(if is_active { config::BG } else { config::WHITE })
                .line_height(LineHeight::Relative(1.0))
                .align_x(Horizontal::Center)
                .align_y(Vertical::Center)
        )
        .on_press(Message::SwitchToWorkspace(id))
        .width(Length::Fixed(16.0))
        .height(Length::Fixed(16.0))
        .padding(0)
        .style(move |_, status| button::Style {
            background: Some(Background::Color(if is_active { config::WHITE } else { config::ACCENT })),
            border: iced::border::Border { radius: 8.0.into(), ..Default::default() },
            text_color: if is_active { config::BG } else { config::WHITE },
            shadow: if status == button::Status::Hovered {
                Shadow {
                    color: Color::from_rgba(1.0, 1.0, 1.0, 0.2),
                    offset: Vector::new(0.0, 2.0),
                    blur_radius: 4.0,
                }
            } else {
                Shadow::default()
            },
            ..Default::default()
        })
    };

    let mut left_row = row![].spacing(6).align_y(Vertical::Center);
    for &id in &app.left_workspaces { left_row = left_row.push(ws_circle(id, app.active_workspace)); }

    let mut right_row = row![].spacing(6).align_y(Vertical::Center);
    for &id in &app.right_workspaces { right_row = right_row.push(ws_circle(id, app.active_workspace)); }

    container(row![left_row, text(&app.current_time).size(config::FONT_CLOCK).color(config::WHITE), right_row].spacing(15).align_y(Vertical::Center))
        .width(Length::Fill).height(Length::Fill).align_x(Horizontal::Center).align_y(Vertical::Center).into()
}
