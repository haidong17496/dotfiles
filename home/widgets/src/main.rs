mod spring;
mod media;
mod notification;
mod config; // NEW
mod view;   // NEW
mod listener;
mod island;

use iced_layershell::build_pattern::application;
use iced_layershell::settings::LayerShellSettings;
use iced_layershell::reexport::{Anchor, Layer};
use iced_layershell::Appearance; 
use iced::{Color, Font}; 

use island::DynamicIsland;

pub fn main() -> Result<(), iced_layershell::Error> {
    // Note: size is initial window size, logic in island.rs handles centering input region
    let layer_settings = LayerShellSettings {
        size: Some((config::WINDOW_WIDTH as u32, config::WINDOW_HEIGHT as u32)), 
        exclusive_zone: -1,
        anchor: Anchor::Top,
        layer: Layer::Top,
        ..Default::default()
    };

    application("DynamicIsland", DynamicIsland::update, DynamicIsland::view)
        .theme(|_| iced::Theme::Dark)
        .subscription(DynamicIsland::subscription)
        .layer_settings(layer_settings)
        .default_font(Font::with_name("JetBrainsMono Nerd Font")) 
        .style(|_theme, _| Appearance {
            background_color: Color::TRANSPARENT,
            text_color: Color::WHITE,
        })
        .run_with(DynamicIsland::new)
}
