import SwiftUI

@main
struct PennyWiseCourseworkApp: App {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                LaunchScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2 секунди
                            isFirstLaunch = false
                        }
                    }
            } else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
