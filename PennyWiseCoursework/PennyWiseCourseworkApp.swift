import SwiftUI

@main
struct PennyWiseCourseworkApp: App {
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    @State private var doneLoading = false
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            if !doneLoading {
                LoadView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.doneLoading = true
                            }
                        }
                    }
            } else {
                if isFirstTime {
                    LaunchScreen()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isFirstTime = false
                            }
                        }
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                } else {
                    ContentView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                }
            }
        }
    }
}
