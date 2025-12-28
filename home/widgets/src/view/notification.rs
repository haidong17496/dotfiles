use iced::widget::{container, row, column, text};
use iced::widget::text::LineHeight;
use iced::{Background, Element, Length, Padding};
use iced::alignment::{Horizontal, Vertical};

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
        // FIX: Use config::size::...
        .width(Length::Fixed(config::size::MAX_WIDTH))
        .height(Length::Fixed(config::size::NOTIF_HEIGHT))
        .padding(Padding { top: 0.0, bottom: 0.0, left: 20.0, right: 20.0 }).align_x(Horizontal::Left).align_y(Vertical::Center).into()
}
