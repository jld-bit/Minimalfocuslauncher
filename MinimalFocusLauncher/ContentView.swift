import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appStore: AppStore
    @EnvironmentObject private var purchaseManager: PurchaseManager

    @StateObject private var timerModel = FocusTimerViewModel()
    @StateObject private var screenTimeService = ScreenTimeService()

    @State private var draftName = ""
    @State private var draftURLScheme = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Minimal Focus Launcher")
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    screenTimeSection
                    timerSection
                    shortcutsSection
                    preferencesSection
                    purchaseSection
                }
                .padding(24)
                .foregroundStyle(.white)
            }
        }
        .saturation(appStore.grayscaleEnabled ? 0 : 1)
        .task {
            screenTimeService.refresh()
            await purchaseManager.refreshEntitlements()
        }
    }

    private var screenTimeSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Screen Time")
                .font(.title2.weight(.semibold))
            Text(screenTimeService.todayUsageText)
                .font(.title3.monospaced())
                .opacity(0.9)
        }
    }

    private var timerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Focus Timer (25:00)")
                .font(.title2.weight(.semibold))

            Text(timerModel.displayText)
                .font(.system(size: 44, weight: .bold, design: .monospaced))

            HStack(spacing: 12) {
                Button(timerModel.isRunning ? "Running" : "Start") {
                    timerModel.start()
                }
                .buttonStyle(.borderedProminent)
                .disabled(timerModel.isRunning)

                Button("Reset") {
                    timerModel.reset()
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var shortcutsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Apps")
                .font(.title2.weight(.semibold))

            if appStore.shortcuts.isEmpty {
                Text("No apps added yet")
                    .opacity(0.7)
                    .font(.title3)
            } else {
                ForEach(appStore.shortcuts) { shortcut in
                    HStack {
                        Link(shortcut.name, destination: URL(string: shortcut.urlScheme) ?? URL(string: "about:blank")!)
                            .font(.title3.weight(.medium))
                            .tint(.white)
                        Spacer()
                        Button("Remove") {
                            removeShortcut(id: shortcut.id)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                TextField("App name", text: $draftName)
                    .textFieldStyle(.roundedBorder)
                TextField("URL scheme (e.g. notes://)", text: $draftURLScheme)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button("Add App") {
                        appStore.addShortcut(name: draftName, urlScheme: draftURLScheme)
                        draftName = ""
                        draftURLScheme = ""
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Remove Last") {
                        _ = appStore.shortcuts.popLast()
                    }
                    .buttonStyle(.bordered)
                    .disabled(appStore.shortcuts.isEmpty)
                }
            }
        }
    }

    private var preferencesSection: some View {
        Toggle(isOn: $appStore.grayscaleEnabled) {
            Text("Grayscale mode")
                .font(.title3)
        }
        .toggleStyle(.switch)
    }

    private var purchaseSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Premium")
                .font(.title2.weight(.semibold))

            Text(purchaseManager.hasPremiumThemes ? "Premium themes unlocked" : "Unlock premium themes")
                .font(.title3)

            Button(purchaseManager.hasPremiumThemes ? "Unlocked" : "Buy Premium Themes") {
                Task { await purchaseManager.buyPremiumThemes() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(purchaseManager.hasPremiumThemes)
        }
    }

    private func removeShortcut(id: UUID) {
        appStore.shortcuts.removeAll { $0.id == id }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppStore())
        .environmentObject(PurchaseManager())
}
