import SwiftUI

struct FilterTab: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)],
        animation: .default)
    private var allTransactions: FetchedResults<TransactionEntity>

    @State private var searchText = ""

    var filteredTransactions: [TransactionEntity] {
        if searchText.isEmpty {
            return Array(allTransactions)
        } else {
            return allTransactions.filter { transaction in
                transaction.title?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
    }

    var body: some View {
        ZStack {

            Color(UIColor.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Text("Filter Transactions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.top, 40)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search Transactions", text: $searchText)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 4)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(filteredTransactions, id: \.self) { transaction in
                            VStack(alignment: .leading) {
                                Text(transaction.title ?? "No Title")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 2)

                                Text("Amount: \(transaction.amount ?? 0, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Divider()
                                    .padding(.top, 10)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
        }
    }
}
