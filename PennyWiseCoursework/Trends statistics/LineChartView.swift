import SwiftUI
import SwiftUICharts
import Charts

struct LineChartView: View {
    let transactions: [TransactionEntity]
    let type: String

    var body: some View {
        Chart {
            ForEach(groupTransactionsByDate(), id: \.0) { (date, total) in
                LineMark(
                    x: .value("Date", date),
                    y: .value("Total", total)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(type == "expense" ? .red : .green)
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel(formatDate(value.as(Date.self) ?? Date()))
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisValueLabel("\(value.as(Double.self) ?? 0, specifier: "%.0f") UAH")
            }
        }
    }

    private func groupTransactionsByDate() -> [(Date, Double)] {
        let grouped = Dictionary(grouping: transactions) { transaction in
            Calendar.current.startOfDay(for: transaction.date ?? Date())
        }

        return grouped.map { (date, transactions) in
            (date, transactions.reduce(0) { $0 + $1.amount })
        }
        .sorted(by: { $0.0 < $1.0 })
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
}
