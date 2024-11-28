import SwiftUI

struct CircularButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(width: 55, height: 55)
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(.purple)
            }
        }
        .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
