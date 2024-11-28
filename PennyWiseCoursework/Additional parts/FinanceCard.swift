import SwiftUI

struct FinanceCard: View {
    var income: Double
    var expense: Double
    var currencyCode: String
    
    var balance: Double {
        return income - expense
    }
    
    var expensePercentage: CGFloat {
        let total = income + expense
        return total == 0 ? 0 : CGFloat(expense / total)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.75), Color.blue.opacity(0.75)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 180)
                .shadow(color: Color.gray.opacity(0.15), radius: 8, x: 0, y: 4)
                .padding(.horizontal)

            VStack(spacing: 16) {
                Text("\(balance, specifier: "%.2f") \(currencyCode)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)

                Divider()
                    .background(Color.white.opacity(0.6))
                    .padding(.horizontal, 40)

                HStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.green)
                        Text("Income")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        Text("\(income, specifier: "%.2f") \(currencyCode)")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }

                    VStack(spacing: 6) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.red)
                        Text("Expense")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        Text("\(expense, specifier: "%.2f") \(currencyCode)")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                }
                
                ProgressBar(value: expensePercentage)
                    .frame(height: 6)
                    .cornerRadius(3)
                    .padding(.horizontal, 40)
            }
            .padding()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)  
    }
}

struct ProgressBar: View {
    var value: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.white.opacity(0.2))
                .frame(height: 6)
            
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.red)
                .frame(width: value * 200, height: 6) // Adjust width based on value
        }
    }
}

struct FinanceCard_Previews: PreviewProvider {
    static var previews: some View {
        FinanceCard(income: 5000, expense: 3000, currencyCode: "USD")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
