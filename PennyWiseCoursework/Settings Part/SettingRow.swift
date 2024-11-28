import SwiftUI
import UserNotifications


struct SettingRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.purple)
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}
