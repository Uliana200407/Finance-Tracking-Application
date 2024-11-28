import UserNotifications

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Notification access granted")
        } else {
            print("Notification access denied")
        }
    }
}

func logout() {
    print("Logging out user...")
}
