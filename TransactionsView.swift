//
//  TransactionsView.swift
//  PennyWiseFinal
//
//  Created by mac on 26.11.2024.
//

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
                    Label("Charts", systemImage: "chart.pie.fill")
                }
                .tag(Tab.charts)

            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(Tab.settings)
        }
        .accentColor(Color.purple) // Фіолетовий колір для іконок
    }
}


struct TransactionsTab: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionEntity.date, ascending: false)],
        animation: .default)
    private var allTransactions: FetchedResults<TransactionEntity>

    @State private var showingAddTransaction = false
    @State private var selectedFilter: String? = nil // Фільтр за категоріями (доходи, витрати)
    @State private var selectedCurrency: Currency = Currency.availableCurrencies[0] // Початкова валюта: UAH

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Картка статистики
                FinanceCard(
                    income: calculateTotal(for: "income"),
                    expense: calculateTotal(for: "expense"),
                    currencyCode: selectedCurrency.code
                )

                // Кнопки та слайдери
                VStack(spacing: 20) {
                    // Дві кнопки: Календар і Додати транзакцію
                    HStack(spacing: 30) {
                        CircularButton(icon: "calendar") {
                            print("Сортування за датою")
                        }

                        CircularButton(icon: "plus.circle.fill") {
                            showingAddTransaction.toggle()
                        }
                    }

                    // Слайдер для вибору фільтру
                    Picker("Filter", selection: $selectedFilter) {
                        Text("All").tag(nil as String?)
                        Text("Income").tag("income" as String?)
                        Text("Expense").tag("expense" as String?)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    // Слайдер для вибору валюти
                    Picker("Currency", selection: $selectedCurrency) {
                        ForEach(Currency.availableCurrencies, id: \.self) { currency in
                            Text(currency.code).tag(currency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                }

                // Список транзакцій із нотатками
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
                .listStyle(InsetGroupedListStyle())
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView()
            }
            .navigationTitle("Transactions")
        }
    }

    // Метод для фільтрації транзакцій
    private func filteredTransactions() -> [TransactionEntity] {
        if let filter = selectedFilter {
            return allTransactions.filter { $0.type == filter }
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
}

import SwiftUI

struct TransactionDetailView: View {
    let transaction: TransactionEntity
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Заголовок
                VStack(spacing: 10) {
                    Text(transaction.title ?? "Transaction")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)

                    Text("\(String(format: "%.2f", transaction.amount)) UAH")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(transaction.type == "income" ? .green : .red)

                    if let date = transaction.date {
                        Text(date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .multilineTextAlignment(.center)

                // Відображення фото
                ZStack {
                    if let selectedImage = selectedImage {
                        // Показати вибране зображення
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                    } else if let imageData = transaction.photo, let uiImage = UIImage(data: imageData) {
                        // Показати зображення з бази
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.gray.opacity(0.2), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                    } else {
                        // Порожній контейнер, якщо фото відсутнє
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.purple.opacity(0.1))
                            .frame(height: 200)
                            .overlay(
                                Text("No Photo Available")
                                    .font(.headline)
                                    .foregroundColor(.purple)
                            )
                            .padding(.horizontal)
                    }
                }

                // Кнопка для додавання або зміни фото
                Button(action: {
                    showingImagePicker.toggle()
                }) {
                    HStack {
                        Image(systemName: "camera.fill")
                        Text(selectedImage == nil ? "Add Photo" : "Change Photo")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                // Нотатки
                if let notes = transaction.notes, !notes.isEmpty {
                    VStack(spacing: 10) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.purple)

                        Text(notes)
                            .font(.body)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding(.top, 20)
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: savePhoto) {
            ImagePicker(image: $selectedImage)
        }
        .navigationBarTitle("Transaction Details", displayMode: .inline)
    }

    private func savePhoto() {
        // Зберегти вибране фото в Core Data
        if let selectedImage = selectedImage, let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
            transaction.photo = imageData

            do {
                try transaction.managedObjectContext?.save()
            } catch {
                print("Failed to save photo: \(error)")
            }
        }
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

                // Доходи та витрати
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
            // Фото, якщо є
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

// Модель транзакції
struct Transaction: Identifiable {
    let id = UUID() // Унікальний ідентифікатор для кожної транзакції
    let title: String
    let date: Date
    let amount: Double
    let type: TransactionType
}


enum TransactionType {
    case income, expense
}




struct SettingsTab: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account")) {
                    SettingRow(icon: "person.circle", title: "Profile")
                    SettingRow(icon: "lock.circle", title: "Privacy")
                }
                Section(header: Text("App Settings")) {
                    SettingRow(icon: "gear", title: "Preferences")
                    SettingRow(icon: "info.circle", title: "About")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
        }
    }
}

struct SettingRow: View {
    var icon: String
    var title: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.purple)
                .frame(width: 32, height: 32)
            Text(title)
                .font(.headline)
        }
    }
}

struct FilterTab: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Filter Transactions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                HStack(spacing: 15) {
                    FilterButton(title: "By Date", icon: "calendar")
                    FilterButton(title: "By Amount", icon: "dollarsign.circle")
                }

                HStack(spacing: 15) {
                    FilterButton(title: "By Type", icon: "tag")
                    FilterButton(title: "By Category", icon: "list.bullet")
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .navigationTitle("")
            .navigationBarHidden(true)
        }
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
