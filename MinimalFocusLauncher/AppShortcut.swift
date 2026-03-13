import Foundation

struct AppShortcut: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var urlScheme: String

    init(id: UUID = UUID(), name: String, urlScheme: String) {
        self.id = id
        self.name = name
        self.urlScheme = urlScheme
    }
}
