import Foundation

final class ScreenTimeService: ObservableObject {
    @Published var todayUsageText: String = "Screen Time unavailable"

    func refresh() {
        // A production integration would use FamilyControls/DeviceActivity APIs,
        // with the required entitlements and user authorization.
        // This placeholder keeps behavior safe when APIs are unavailable.
        todayUsageText = "Screen Time unavailable on this build"
    }
}
