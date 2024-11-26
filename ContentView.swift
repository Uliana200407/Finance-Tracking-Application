//
//  ContentView.swift
//  PennyWiseFinal
//
//  Created by mac on 26.11.2024.
//

import SwiftUI
import CoreData
//
//  ContentView.swift
//  PennyWiseFinal
//
//  Created by mac on 26.11.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            // Transactions Tab
            TransactionsTab()
                .tabItem {
                    Label("Transactions", systemImage: "list.dash")
                }

            // Filter Tab
            FilterTab()
                .tabItem {
                    Label("Filter", systemImage: "magnifyingglass")
                }

            // Charts Tab
            TrendsTab()
                .tabItem {
                    Label("Charts", systemImage: "chart.pie.fill")
                }

            // Settings Tab
            SettingsTab()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .accentColor(.purple) // Змінює колір активної вкладки на фіолетовий
    }
}

