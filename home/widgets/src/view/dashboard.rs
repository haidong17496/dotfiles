use iced::widget::{button, container, row, text};
use iced::widget::text::LineHeight;
use iced::{Background, Color, Element, Length, Shadow, Vector, Padding};
use iced::alignment::{Horizontal, Vertical};
use iced::font::{Font, Weight}; 

use crate::island::{DynamicIsland, Message};
use crate::config;

fn get_battery_icon(level: f32, is_charging: bool) -> (String, Color) {
    let (mut icon, mut color) = match level as i32 {
        0..=20 => ("\u{f244}".to_string(), config::NOTIF_DEFAULT), 
        21..=40 => ("\u{f243}".to_string(), config::WHITE),       
        41..=60 => ("\u{f242}".to_string(), config::WHITE),       
        61..=80 => ("\u{f241}".to_string(), config::WHITE),       
        _ => ("\u{f240}".to_string(), config::WHITE),       
    };

    if is_charging {
        icon = "\u{f0e7}".to_string(); 
        color = config::NOTIF_MUSIC; 
    }
    
    (icon, color)
}

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

    let make_stable_row = |ids: &Vec<i32>| {
        let mut r = row![].spacing(6).align_y(Vertical::Center);
        for &id in ids { 
            r = r.push(ws_circle(id, app.active_workspace)); 
        }
        
        container(r)
            .height(Length::Fixed(16.0))
            .align_y(Vertical::Center)
    };

    let left_container = make_stable_row(&app.left_workspaces);
    let right_container = make_stable_row(&app.right_workspaces);

    let (bat_icon, bat_color) = get_battery_icon(app.battery_level, app.is_charging);

    let battery_widget = row![
        container(
            text(bat_icon)
                .font(Font::with_name("JetBrainsMono Nerd Font"))
                .size(14)
                .color(bat_color)
                .line_height(LineHeight::Relative(1.0))
        )
        .width(Length::Fixed(18.0)) 
        .align_x(Horizontal::Center), // FIX: Use align_x instead of center_x
        
        text(format!("{}%", app.battery_level))
            .size(config::FONT_WS)
            .color(config::WHITE)
            .line_height(LineHeight::Relative(1.0))
    ]
    .spacing(6) 
    .align_y(Vertical::Center);

    let mut main_row = row![
        left_container, 
        text(&app.current_time)
            .size(config::FONT_CLOCK)
            .color(config::WHITE)
            .line_height(LineHeight::Relative(1.0)), 
        right_container,
        container(battery_widget)
            .height(Length::Fixed(16.0))
            .align_y(Vertical::Center)
    ]
    .spacing(15)
    .align_y(Vertical::Center);

    if !app.notification_history.is_empty() {
        let notification_widget = container(
            text("\u{f0f3}") 
                .font(Font::with_name("JetBrainsMono Nerd Font"))
                .size(14)
                .color(config::NOTIF_BROWSER) 
                .line_height(LineHeight::Relative(1.0))
        );
        
        main_row = main_row.push(notification_widget);
    }

    container(main_row)
        .width(Length::Fill)
        .height(Length::Fixed(config::size::DASHBOARD_HEIGHT)) 
        .padding(Padding { left: 20.0, right: 20.0, ..Default::default() }) 
        .align_x(Horizontal::Center)
        .align_y(Vertical::Center)
        .into()
}
