use zbus::{interface, ConnectionBuilder};
use tokio::sync::mpsc;
use std::collections::HashMap;
use zbus::zvariant::Value;

#[derive(Debug, Clone)]
pub struct NotificationData {
    pub summary: String,
    pub body: String,
    pub app_name: String,
}

struct NotifyServer {
    sender: mpsc::Sender<NotificationData>,
}

#[interface(name = "org.freedesktop.Notifications")]
impl NotifyServer {
    async fn notify(
        &mut self,
        app_name: String,
        _replaces_id: u32,
        _app_icon: String,
        summary: String,
        body: String,
        _actions: Vec<String>,
        _hints: HashMap<String, Value<'_>>,
        _timeout: i32,
    ) -> u32 {
        println!("🔔 Notification Received: {}", summary);
        
        let _ = self.sender.send(NotificationData { 
            summary, 
            body, 
            app_name 
        }).await;
        
        1 
    }

    async fn get_server_information(&self) -> (String, String, String, String) {
        ("Island".to_string(), "Nekoma".to_string(), "0.1".to_string(), "1.2".to_string())
    }

    async fn get_capabilities(&self) -> Vec<String> {
        vec!["body".to_string()]
    }

    async fn close_notification(&self, _id: u32) {}
}

pub async fn listen() -> mpsc::Receiver<NotificationData> {
    let (tx, rx) = mpsc::channel(10);

    tokio::spawn(async move {
        let server = NotifyServer { sender: tx };
        
        println!("🔌 Attempting to connect to DBus...");

        let conn_result = ConnectionBuilder::session();
        
        if let Ok(builder) = conn_result {
            let conn_built = builder
                .name("org.freedesktop.Notifications")
                .and_then(|b| b.serve_at("/org/freedesktop/Notifications", server));

            match conn_built {
                Ok(b) => {
                    match b.build().await {
                        Ok(_conn) => {
                            println!("✅ Notification Server Running! Waiting for messages...");
                            std::future::pending::<()>().await;
                        }
                        Err(e) => {
                            println!("❌ Failed to build DBus connection: {}", e);
                            println!("   (Check if another notification daemon is running?)");
                        }
                    }
                }
                Err(e) => println!("❌ Failed to setup DBus name/path: {}", e),
            }
        } else {
            println!("❌ Could not connect to Session Bus.");
        }
    });

    rx
}
