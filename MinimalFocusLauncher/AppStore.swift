import Foundation

final class AppStore: ObservableObject {
    @Published var shortcuts: [AppShortcut] = [] {
        didSet { persistShortcuts() }
    }

    @Published var grayscaleEnabled: Bool = false {
        didSet { defaults.set(grayscaleEnabled, forKey: Keys.grayscaleEnabled) }
    }

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let shortcuts = "savedShortcuts"
        static let grayscaleEnabled = "grayscaleEnabled"
    }

    init() {
        loadState()
    }

    func addShortcut(name: String, urlScheme: String) {
        let cleanedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedURL = urlScheme.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanedName.isEmpty, !cleanedURL.isEmpty else { return }

        shortcuts.append(AppShortcut(name: cleanedName, urlScheme: cleanedURL))
    }

    func removeShortcuts(at offsets: IndexSet) {
        shortcuts.remove(atOffsets: offsets)
    }

    private func loadState() {
        grayscaleEnabled = defaults.bool(forKey: Keys.grayscaleEnabled)

        guard let data = defaults.data(forKey: Keys.shortcuts) else {
            shortcuts = []
            return
        }

        do {
            shortcuts = try JSONDecoder().decode([AppShortcut].self, from: data)
        } catch {
            shortcuts = []
        }
    }

    private func persistShortcuts() {
        do {
            let data = try JSONEncoder().encode(shortcuts)
            defaults.set(data, forKey: Keys.shortcuts)
        } catch {
            // Intentionally fail silently for this minimal implementation.
        }
    }
}
