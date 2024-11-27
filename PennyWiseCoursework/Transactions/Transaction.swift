import SwiftUI
import CoreData

struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let amount: Double
    let type: TransactionType
}
