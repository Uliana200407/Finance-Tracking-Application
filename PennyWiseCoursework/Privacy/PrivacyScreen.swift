import SwiftUI
import CoreLocation
import AVFoundation
import UserNotifications
import SwiftUI
import CoreLocation
import UserNotifications

struct PrivacyScreen: View {
    @State private var locationAccess: Bool = false
    @State private var notificationsAccess: Bool = false
    @State private var isLoggedIn: Bool = true // Simulate login state
    @State private var showPrivacyPolicy = false

    let locationManager = LocationManager()

    // Request location access
    func requestLocationAccess() {
        locationManager.requestLocationPermission()
    }

    // Request notifications access
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    notificationsAccess = true
                    print("Notification access granted")
                } else {
                    notificationsAccess = false
                    print("Notification access denied")
                }
            }
        }
    }

    // Check current notification settings
    func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationsAccess = settings.authorizationStatus == .authorized
                print("Notification access status: \(settings.authorizationStatus == .authorized ? "Granted" : "Denied")")
            }
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Permissions")) {
                    Toggle(isOn: $locationAccess) {
                        Text("Location Access")
                    }
                    .onChange(of: locationAccess) { value in
                        if value {
                            requestLocationAccess()
                        }
                    }

                    Toggle(isOn: $notificationsAccess) {
                        Text("Push Notifications")
                    }
                    .onChange(of: notificationsAccess) { value in
                        if value {
                            requestNotificationPermission()
                        }
                    }
                }

                Section(header: Text("Information")) {
                    Text("We respect your privacy and handle your data with care. For more details, please review our Privacy Policy.")
                }

                Section {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("Read Privacy Policy")
                    }
                }

                Section {
                    Button(action: {
                        // Handle log out action or other related tasks
                    }) {
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Privacy Settings")
        }
        .onAppear {
            checkNotificationSettings() // Check notification status when the screen appears
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.horizontal)

                // Privacy policy content
                Text("""
                We value your privacy and are committed to protecting your personal data. This policy outlines how we collect, store, and use your information.

                **Information We Collect:**
                - **Personal Information**: We collect your name, email, and other relevant information when you sign up for our service.
                - **Usage Data**: We track how you interact with our app to improve your experience.
                - **Permissions**: We request access to your location, notifications, and camera (if applicable) to provide better services.

                **How We Use Your Information:**
                - **Location Data**: Used to provide location-based services.
                - **Push Notifications**: To send you important updates and alerts related to our services.
                - **Camera Access**: Only when necessary to enable camera-related features (if applicable).

                **Your Rights:**
                - You can manage and revoke any permissions you've granted at any time through the app's settings.
                - You can delete your account and personal data by contacting support.

                For any questions or concerns about our privacy practices, please contact our support team.
                """)
                    .font(.body)
                    .lineSpacing(6)
                    .padding(.horizontal)
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding(.bottom, 20)
        }
        .navigationBarTitle("Privacy Policy", displayMode: .inline)
    }
}

struct LocationManager {
    func requestLocationPermission() {
        // Location permission request logic here
        print("Requesting location access permission")
    }
}
