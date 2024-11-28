import SwiftUI
import UserNotifications

struct SettingsTab: View {
    @State private var notificationsEnabled: Bool = true

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    notificationsEnabled = true
                    print("Notification access granted")
                } else {
                    notificationsEnabled = false
                    print("Notification access denied")
                }
            }
        }
    }

    func revokeNotificationPermission() {
        print("Notifications disabled")
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    NavigationLink(destination: ProfileScreen()) {
                        SettingRow(icon: "person.circle", title: "Profile")
                    }
                    NavigationLink(destination: PrivacyScreen()) {
                        SettingRow(icon: "lock.circle", title: "Privacy")
                    }
                }

                Section(header: Text("App Settings")) {
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.circle.fill")
                            Text("Enable Notifications")
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
                    .onChange(of: notificationsEnabled) { value in
                        if value {
                            requestNotificationPermission()
                        } else {
                            revokeNotificationPermission()
                        }
                    }
                }

                Section(header: Text("Help & Legal")) {
                    NavigationLink(destination: TermsAndConditionsScreen()) {
                        SettingRow(icon: "doc.text", title: "Terms & Conditions")
                    }
                }

                Section {
                    Button(action: {
                        // Log out action
                        print("Logging out...")
                    }) {
                        HStack {
                            Image(systemName: "power")
                            Text("Logout")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .accentColor(.purple)
        }
    }
}
