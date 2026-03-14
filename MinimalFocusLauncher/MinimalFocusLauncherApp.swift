import SwiftUI

@main
struct MinimalFocusLauncherApp: App {
    @StateObject private var appStore = AppStore()
    @StateObject private var purchaseManager = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStore)
                .environmentObject(purchaseManager)
        }
    }
}
