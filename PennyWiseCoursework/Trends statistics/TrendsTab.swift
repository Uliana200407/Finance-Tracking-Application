import SwiftUI
import Charts

struct TrendsTab: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: true)],
        animation: .default
    )
    private var transactions: FetchedResults<TransactionEntity>

    @State private var selectedType: String = "expense"
    @State private var selectedPeriod: String = "Week"
    @State private var filteredTransactions: [TransactionEntity] = []

    private let periods = ["Week", "Month", "Year"]

    var body: some View {
        NavigationView {
            VStack {
                Picker("Type", selection: $selectedType) {
                    Text("Expenses").tag("expense")
                    Text("Income").tag("income")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Picker("Period", selection: $selectedPeriod) {
                    ForEach(periods, id: \.self) { period in
                        Text(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                if !filteredTransactions.isEmpty {
                    LineChartView(transactions: filteredTransactions, type: selectedType)
                        .frame(height: 300)
                        .padding()
                } else {
                    Text("No data for the selected period.")
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
            }
            .navigationTitle("Trends")
            .onAppear { filterTransactions() }
            .onChange(of: selectedPeriod) { _ in filterTransactions() }
            .onChange(of: selectedType) { _ in filterTransactions() }
        }
    }

    private func filterTransactions() {
        let calendar = Calendar.current
        let now = Date()

        filteredTransactions = transactions.filter { transaction in
            guard transaction.type == selectedType else { return false }

            let diff = calendar.dateComponents([.day, .month, .year], from: transaction.date ?? now, to: now)
            switch selectedPeriod {
            case "Week":
                return diff.day ?? 0 <= 7
            case "Month":
                return diff.month ?? 0 < 1
            case "Year":
                return diff.year ?? 0 < 1
            default:
                return false
            }
        }
    }
}
