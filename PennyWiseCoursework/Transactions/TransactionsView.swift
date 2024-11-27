import SwiftUI
import CoreData

struct TransactionsView: View {
    @State private var selectedTab: Tab = .transactions

    enum Tab {
        case transactions, filter, charts, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TransactionsTab()
                .tabItem {
                    Label("Transactions", systemImage: "list.dash")
                }
                .tag(Tab.transactions)

            FilterTab()
                .tabItem {
                    Label("Filter", systemImage: "magnifyingglass")
                }
                .tag(Tab.filter)

            TrendsTab()
                .tabItem {
                    Label("Trends", systemImage: "chart.pie.fill")
                }
                .tag(Tab.charts)

            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .accentColor(Color.purple)
    }
}




struct FinanceCard: View {
    var income: Double
    var expense: Double
    var currencyCode: String // Код валюти

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple.opacity(0.85), Color.blue.opacity(0.85)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 180)
                .shadow(color: Color.gray.opacity(0.2), radius: 10, x: 0, y: 5)

            VStack(spacing: 16) {
                // Баланс
                Text("\(income - expense, specifier: "%.2f") \(currencyCode)")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)

                Divider()
                    .background(Color.white.opacity(0.6))
                    .padding(.horizontal, 20)

                HStack(spacing: 50) {
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.green)
                        Text("Income")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        Text("\(income, specifier: "%.2f") \(currencyCode)")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.red)
                        Text("Expense")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))
                        Text("\(expense, specifier: "%.2f") \(currencyCode)")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .padding(.horizontal)
    }
}



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



struct SettingsTab: View {
    @State private var notificationsEnabled: Bool = true

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                                    NavigationLink(destination: ProfileScreen()) {  // Navigating to ProfileScreen
                                        SettingRow(icon: "person.circle", title: "Profile")
                                    }
                                    NavigationLink(destination: Text("Privacy Screen")) {
                                        SettingRow(icon: "lock.circle", title: "Privacy")
                                    }
                                }

                // App Settings Section
                Section(header: Text("App Settings")) {
                    NavigationLink(destination: Text("Preferences Screen")) {
                        SettingRow(icon: "gear", title: "Preferences")
                    }
                    NavigationLink(destination: Text("About Screen")) {
                        SettingRow(icon: "info.circle", title: "About")
                    }

                    // Notifications Toggle
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.circle.fill")
                            Text("Enable Notifications")
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .purple)) // Set toggle accent color to purple
                }
                
                // Additional section for help and legal info
                Section(header: Text("Help & Legal")) {
                    NavigationLink(destination: Text("Terms & Conditions")) {
                        SettingRow(icon: "doc.text", title: "Terms & Conditions")
                    }
                    NavigationLink(destination: Text("Privacy Policy")) {
                        SettingRow(icon: "shield.lefthalf.fill", title: "Privacy Policy")
                    }
                }

                // Logout option
                Section {
                    Button(action: {
                        // Logout functionality goes here
                        print("Logging out...")
                    }) {
                        HStack {
                            Image(systemName: "power")
                            Text("Logout")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .accentColor(.purple) // Set the global accent color to purple
        }
    }
}

struct SettingRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.purple) // Icon color
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}


struct FilterTab: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)],
        animation: .default)
    private var allTransactions: FetchedResults<TransactionEntity>

    @State private var searchText = ""

    // Filter transactions based on the search text
    var filteredTransactions: [TransactionEntity] {
        if searchText.isEmpty {
            return Array(allTransactions) // Return all transactions if search is empty
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


struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $text)
                .padding(10)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: Color.gray.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal, 20)
    }
}


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


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
