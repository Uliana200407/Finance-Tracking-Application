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
