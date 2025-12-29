use iced::widget::{container, row, column, text, button, scrollable};
use iced::widget::text::LineHeight;
use iced::{Background, Element, Length, Padding, Color};
use iced::alignment::{Horizontal, Vertical};
use iced::font::{Font, Weight};

use crate::island::{DynamicIsland, Message};
use crate::notification::NotificationData;
use crate::config;

fn get_app_style(app_name: &str) -> (&'static str, iced::Color) {
    match app_name.to_lowercase().as_str() {
        "firefox" | "chrome" | "brave" | "zen" | "chromium" => ("\u{f0ac}", config::NOTIF_BROWSER),
        "slack" | "discord" | "telegram" | "signal" => ("\u{f075}", config::NOTIF_CHAT),
        "spotify" | "rhythmbox" | "music" | "mpd" => ("\u{f001}", config::NOTIF_MUSIC),
        "alacritty" | "kitty" | "terminal" | "foot" => ("\u{f120}", config::NOTIF_TERM),
        _ => ("\u{f0f3}", config::NOTIF_DEFAULT)
    }
}

// --- POP-UP VIEW ---
pub fn view<'a>(app: &'a DynamicIsland) -> Element<'a, Message> {
    let data = app.notification_info.clone().unwrap_or(NotificationData { summary: "System".to_string(), body: "".to_string(), app_name: "System".to_string() });
    let (icon_char, bg_color) = get_app_style(&data.app_name);

    let icon_box = container(text(icon_char).size(28).color(config::WHITE).line_height(LineHeight::Relative(1.0)).align_x(Horizontal::Center).align_y(Vertical::Center))
        .width(50).height(50).align_x(Horizontal::Center).align_y(Vertical::Center)
        .style(move |_| container::Style {
            background: Some(Background::Color(bg_color)),
            border: iced::border::Border { radius: 10.0.into(), ..Default::default() }, ..Default::default()
        });

    let text_info = column![
        text(data.summary).size(config::FONT_TITLE).color(config::WHITE).wrapping(iced::widget::text::Wrapping::None), 
        text(data.body).size(config::FONT_SUBTITLE).color(config::MUTED).wrapping(iced::widget::text::Wrapping::None), 
    ].spacing(4).align_x(Horizontal::Left);

    container(row![icon_box, text_info].spacing(15).align_y(Vertical::Center))
        .width(Length::Fixed(config::size::MAX_WIDTH))
        .height(Length::Fixed(config::size::NOTIF_HEIGHT))
        .padding(Padding { top: 0.0, bottom: 0.0, left: 20.0, right: 20.0 }).align_x(Horizontal::Left).align_y(Vertical::Center).into()
}

// --- NOTIFICATION CENTER VIEW ---
pub fn view_center<'a>(app: &'a DynamicIsland) -> Element<'a, Message> {
    let title = text("Notifications")
        .size(config::FONT_TITLE)
        .font(Font { weight: Weight::Bold, ..Default::default() })
        .color(config::WHITE);

    let mut list_col = column![].spacing(10);

    for notif in &app.notification_history {
        let (icon_char, bg_color) = get_app_style(&notif.app_name);
        
        let icon = container(
            text(icon_char)
                .size(16)
                .color(config::WHITE)
                .font(Font::with_name("JetBrainsMono Nerd Font"))
        )
        .width(30)
        .height(30)
        .align_x(Horizontal::Center)
        .align_y(Vertical::Center)
        .style(move |_| container::Style {
            background: Some(Background::Color(bg_color)),
            border: iced::border::Border { radius: 6.0.into(), ..Default::default() },
            ..Default::default()
        });

        let content = column![
            text(&notif.summary).size(13).color(config::WHITE),
            text(&notif.body).size(11).color(config::MUTED)
        ].spacing(2);

        let row_item = row![icon, content].spacing(10).align_y(Vertical::Center);
        
        list_col = list_col.push(row_item);
    }

    let scroll_area = scrollable(list_col)
        .height(Length::Fill)
        .width(Length::Fill);

    let clear_btn = button(
        text("Clear All")
            .size(12)
            .color(config::WHITE) 
            .width(Length::Fill)          // FIX 1: Make text take full width
            .align_x(Horizontal::Center)  // FIX 2: Now it can center itself in that space
    )
    .on_press(Message::ClearAllNotifications)
    .width(Length::Fill)
    .padding(8)
    .style(|_, _| button::Style {
        background: Some(Background::Color(config::BG)), 
        border: iced::border::Border { 
            radius: 8.0.into(), 
            width: 1.0, 
            color: Color::from_rgba(1.0, 1.0, 1.0, 0.2) 
        },
        text_color: config::WHITE,
        ..Default::default()
    });

    container(
        column![
            title,
            scroll_area,
            clear_btn
        ]
        .spacing(15)
        .height(Length::Fill)
    )
    .width(Length::Fixed(config::size::MAX_WIDTH))
    .padding(20)
    .into()
}
