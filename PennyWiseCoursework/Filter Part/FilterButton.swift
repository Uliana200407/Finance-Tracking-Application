import SwiftUI

struct FilterButton: View {
    var title: String
    var icon: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(.purple)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 4)

            Text(title)
                .font(.footnote)
                .foregroundColor(.black)
        }
    }
}
