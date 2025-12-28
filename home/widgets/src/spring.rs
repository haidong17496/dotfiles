#[derive(Debug, Clone, Copy)]
pub struct Spring {
    pub current: f32,
    pub target: f32,
    speed: f32, 
}

impl Default for Spring {
    fn default() -> Self {
        Self {
            current: 0.0,
            target: 0.0,
            speed: 0.15, // A good snappy feel
        }
    }
}

impl Spring {
    pub fn new(start_val: f32) -> Self {
        Self {
            current: start_val,
            target: start_val,
            ..Default::default()
        }
    }

    pub fn set_target(&mut self, target: f32) {
        self.target = target;
    }

    pub fn update(&mut self, _dt: f32) -> bool {
        self.current = self.current + (self.target - self.current) * self.speed;

        if (self.current - self.target).abs() < 0.5 {
            self.current = self.target;
            return false; // Stopped
        }
        true // Still moving
    }
}
