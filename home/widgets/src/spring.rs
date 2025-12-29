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
            speed: 0.15, 
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
        let diff = self.target - self.current;

        // PERF FIX: Snap to target when close to stop the animation loop
        if diff.abs() < 0.5 {
            self.current = self.target;
            return false; // Animation stopped
        }

        self.current = self.current + diff * self.speed;
        true // Animation continues
    }
}
