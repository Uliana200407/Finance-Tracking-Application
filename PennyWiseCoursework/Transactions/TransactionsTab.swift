import SwiftUI
import CoreData

struct TransactionsTab: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isAscending = false // Track the sort direction

    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\TransactionEntity.date, order: .reverse) // Default descending order
        ],
        animation: .default
    ) private var allTransactions: FetchedResults<TransactionEntity>

    @State private var showingAddTransaction = false
    @State private var selectedFilter: String? = nil
    @State private var selectedCurrency: Currency = Currency.availableCurrencies[0]

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                
                FinanceCard(
                    income: calculateTotal(for: "income"),
                    expense: calculateTotal(for: "expense"),
                    currencyCode: selectedCurrency.code
                )

                VStack(spacing: 12) {
                    HStack(spacing: 24) {
                        CircularButton(icon: "calendar") {
                            isAscending.toggle() 
                            updateSortDirection()
                        }

                        CircularButton(icon: "plus.circle.fill") {
                            showingAddTransaction.toggle()
                        }
                    }

                    Picker("Filter", selection: $selectedFilter) {
                        Text("All").tag(nil as String?)
                        Text("Income").tag("income" as String?)
                        Text("Expense").tag("expense" as String?)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    Picker("Currency", selection: $selectedCurrency) {
                        ForEach(Currency.availableCurrencies, id: \.self) { currency in
                            Text(currency.code).tag(currency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }

                List {
                    ForEach(filteredTransactions()) { transaction in
                        NavigationLink(destination: TransactionDetailView(transaction: transaction)) {
                            TransactionRow(transaction: transaction, currency: selectedCurrency)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                deleteTransaction(transaction)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .navigationTitle("Transactions")
            }
        }
    }

    private func filteredTransactions() -> [TransactionEntity] {
        if let selectedFilter = selectedFilter {
            return allTransactions.filter { $0.type == selectedFilter }
        }
        return Array(allTransactions)
    }
    private func calculateTotal(for type: String) -> Double {
         allTransactions
             .filter { $0.type == type }
             .reduce(0) { $0 + $1.amount } * selectedCurrency.rateToUAH
     }

    private func deleteTransaction(_ transaction: TransactionEntity) {
        withAnimation {
            viewContext.delete(transaction)
            do {
                try viewContext.save()
            } catch {
                print("Error deleting transaction: \(error)")
            }
        }
    }

    private func updateSortDirection() {
        let newSortOrder: SortDescriptor<TransactionEntity> = SortDescriptor(\TransactionEntity.date, order: isAscending ? .forward : .reverse)
        allTransactions.sortDescriptors = [newSortOrder]
    }
}
