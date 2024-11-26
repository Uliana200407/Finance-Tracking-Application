//
//  PennyWiseFinalApp.swift
//  PennyWiseFinal
//
//  Created by mac on 26.11.2024.
//


import SwiftUI

@main

struct PennyWiseFinalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
