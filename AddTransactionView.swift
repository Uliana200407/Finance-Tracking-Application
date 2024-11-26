//
//  AddTransactionView.swift
//  PennyWiseFinal
//
//  Created by mac on 26.11.2024.
//

import SwiftUI
import CoreData
struct AddTransactionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var amount: Double = 0.0
    @State private var type: String = "income" // За замовчуванням "доходи"
    @State private var date: Date = Date()
    @State private var notes: String = "" // Поле для нотаток

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Details")) {
                    TextField("Title", text: $title)
                    TextField("Amount", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                    Picker("Type", selection: $type) {
                        Text("Income").tag("income")
                        Text("Expense").tag("expense")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addTransaction()
                    }
                }
            }
        }
    }

    private func addTransaction() {
        withAnimation {
            let newTransaction = TransactionEntity(context: viewContext)
            newTransaction.id = UUID()
            newTransaction.title = title
            newTransaction.amount = amount
            newTransaction.type = type
            newTransaction.date = date
            newTransaction.notes = notes // Збереження нотаток

            do {
                try viewContext.save()
                dismiss()
            } catch {
                print("Failed to save transaction: \(error)")
            }
        }
    }
}

