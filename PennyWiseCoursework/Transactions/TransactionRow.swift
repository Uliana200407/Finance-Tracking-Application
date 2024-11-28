import SwiftUI

struct TransactionRow: View {
    let transaction: TransactionEntity
    let currency: Currency

    var body: some View {
        HStack {

            if let photoData = transaction.photo, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(Text("N/A").font(.caption).foregroundColor(.gray))
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(transaction.title ?? "Unknown")
                    .fontWeight(.bold)
                Text(transaction.date ?? Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(transaction.amount * currency.rateToUAH, specifier: "%.2f") \(currency.code)")
                .foregroundColor(transaction.type == "income" ? .green : .red)
        }
        .padding(.vertical, 8)
    }
}
