import Foundation

final class FocusTimerViewModel: ObservableObject {
    @Published private(set) var remainingSeconds: Int = 25 * 60
    @Published private(set) var isRunning: Bool = false

    private var timer: Timer?

    var displayText: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }

            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
            } else {
                self.stop()
            }
        }
    }

    func reset() {
        stop()
        remainingSeconds = 25 * 60
    }

    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
}
