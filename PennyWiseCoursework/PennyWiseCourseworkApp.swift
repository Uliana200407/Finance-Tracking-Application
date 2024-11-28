import SwiftUI



@main
struct PennyWiseCourseworkApp: App {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if isFirstTime {
                LaunchScreen()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
