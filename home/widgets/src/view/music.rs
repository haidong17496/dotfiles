use iced::widget::{button, column, container, row, text, canvas::{self, Canvas, Geometry, Path}};
use iced::widget::text::LineHeight;
use iced::{Background, Color, Element, Length, Padding, Point, Size, Rectangle, Renderer};
use iced::alignment::{Horizontal, Vertical};
use iced::font::{Font, Weight}; 
use iced::mouse;

use crate::island::{DynamicIsland, Message};
use crate::config;

// --- MARQUEE WIDGET ---
struct Marquee<'a> {
    text: String,
    offset: f32,
    cache: &'a canvas::Cache,
}

impl<'a> canvas::Program<Message> for Marquee<'a> {
    type State = ();

    fn draw(&self, _state: &Self::State, renderer: &Renderer, _theme: &iced::Theme, bounds: Rectangle, _cursor: mouse::Cursor) -> Vec<Geometry> {
        let geometry = self.cache.draw(renderer, bounds.size(), |frame| {
            let text_element = canvas::Text {
                content: self.text.clone(),
                position: Point::new(self.offset, frame.height() / 2.0),
                color: config::WHITE,
                size: config::FONT_TITLE.into(),
                line_height: LineHeight::Relative(1.0),
                font: Font { weight: Weight::Bold, ..Default::default() },
                horizontal_alignment: Horizontal::Left,
                vertical_alignment: Vertical::Center,
                ..canvas::Text::default()
            };
            frame.fill_text(text_element);
        });
        vec![geometry]
    }
}

// --- PROGRESS BAR WIDGET ---
struct ProgressBar<'a> {
    progress: f32,
    cache: &'a canvas::Cache,
}

impl<'a> canvas::Program<Message> for ProgressBar<'a> {
    type State = ();

    fn draw(&self, _state: &Self::State, renderer: &Renderer, _theme: &iced::Theme, bounds: Rectangle, _cursor: mouse::Cursor) -> Vec<Geometry> {
        let geometry = self.cache.draw(renderer, bounds.size(), |frame| {
            let bar_height = 6.0; 
            let y_offset = (frame.height() - bar_height) / 2.0;
            
            let bg_bar = Path::rectangle(Point::new(0.0, y_offset), Size::new(frame.width(), bar_height));
            frame.fill(&bg_bar, config::ACCENT);
            
            let progress_width = frame.width() * (self.progress / 100.0);
            let fg_bar = Path::rectangle(Point::new(0.0, y_offset), Size::new(progress_width, bar_height));
            frame.fill(&fg_bar, config::WHITE);
        });
        vec![geometry]
    }

    fn update(&self, _state: &mut Self::State, event: canvas::Event, bounds: Rectangle, cursor: mouse::Cursor) -> (canvas::event::Status, Option<Message>) {
        if let canvas::Event::Mouse(mouse::Event::ButtonPressed(mouse::Button::Left)) = event {
            if let Some(position) = cursor.position_in(bounds) {
                let percent = (position.x / bounds.width).max(0.0).min(1.0);
                return (canvas::event::Status::Captured, Some(Message::Seek(percent)));
            }
        }
        (canvas::event::Status::Ignored, None)
    }

    fn mouse_interaction(&self, _state: &Self::State, bounds: Rectangle, cursor: mouse::Cursor) -> mouse::Interaction {
        if cursor.is_over(bounds) { mouse::Interaction::Pointer } else { mouse::Interaction::default() }
    }
}

pub fn view<'a>(app: &'a DynamicIsland) -> Element<'a, Message> {
    let icon = if app.media_info.is_playing { "\u{f001}" } else { "\u{f04c}" };
    
    let album_art = container(
        text(icon).size(30).color(config::WHITE)
        .font(Font::with_name("JetBrainsMono Nerd Font")) 
        .line_height(LineHeight::Relative(1.0))
        .align_x(Horizontal::Center).align_y(Vertical::Center)
    )
    .width(60).height(60)
    .align_x(Horizontal::Center).align_y(Vertical::Center)
    .style(|_| container::Style {
        background: Some(Background::Color(Color::from_rgb8(50, 50, 50))),
        border: iced::border::Border { radius: 10.0.into(), ..Default::default() },
        ..Default::default()
    });

    let song_info: Element<_> = {
        let title_clean = app.media_info.title.replace('\n', " ").replace('\r', "");
        let text_height = Length::Fixed(config::FONT_TITLE as f32 + 6.0); 

        if app.width.current >= config::size::MAX_WIDTH - 5.0 {
            Canvas::new(Marquee { 
                text: title_clean, 
                offset: app.marquee_offset,
                cache: &app.marquee_cache 
            })
            .width(Length::Fill).height(text_height).into()
        } else {
            container(
                text(title_clean)
                .size(config::FONT_TITLE).color(config::WHITE)
                .font(Font { weight: Weight::Bold, ..Default::default() })
                .wrapping(iced::widget::text::Wrapping::None)
                .line_height(LineHeight::Relative(1.0))
            )
            .width(Length::Fill).height(text_height).into()
        }
    };

    let artist_info = container(
        text(&app.media_info.artist)
            .size(config::FONT_SUBTITLE).color(config::MUTED)
            .wrapping(iced::widget::text::Wrapping::None)
            .line_height(LineHeight::Relative(1.0))
    )
    .width(Length::Fill)
    .height(Length::Fixed(config::FONT_SUBTITLE as f32 + 4.0))
    .clip(true);

    let media_btn = |label: &'static str, size: u16, msg: Message| {
        button(text(label).font(Font::with_name("JetBrainsMono Nerd Font")).size(size).color(config::WHITE).line_height(LineHeight::Relative(1.0)).align_x(Horizontal::Center).align_y(Vertical::Center))
        .on_press(msg).padding(0).width(30).height(30)
        .style(move |_, _| button::Style { background: None, text_color: config::WHITE, ..Default::default() })
    };

    let controls = row![
        media_btn("\u{f048}", 18, Message::SkipPrevious),
        media_btn(if app.media_info.is_playing { "\u{f04c}" } else { "\u{f04b}" }, 24, Message::TogglePlayPause),
        media_btn("\u{f051}", 18, Message::SkipNext),
    ].spacing(15).align_y(Vertical::Center);

    let progress_bar = Canvas::new(ProgressBar { 
        progress: app.music_progress.current,
        cache: &app.progress_cache 
    })
    .width(Length::Fill).height(Length::Fixed(20.0));

    container(row![
        album_art, 
        column![
            song_info,
            artist_info,
            container(controls).width(Length::Fill).align_x(Horizontal::Center),
            progress_bar
        ].width(Length::Fill).spacing(2)
    ].spacing(15).align_y(Vertical::Center))
        .width(Length::Fixed(app.width.current))
        .height(Length::Fixed(config::size::MUSIC_HEIGHT))
        .padding(Padding { top: 0.0, bottom: 0.0, left: 15.0, right: 20.0 })
        .align_x(Horizontal::Left).align_y(Vertical::Center).into()
}
