import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            TransactionsTab()
                .tabItem {
                    Label("Transactions", systemImage: "list.dash")
                }

            FilterTab()
                .tabItem {
                    Label("Filter", systemImage: "magnifyingglass")
                }

            TrendsTab()
                .tabItem {
                    Label("Trends", systemImage: "chart.pie.fill")
                }

            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .accentColor(.purple)
    }
}
