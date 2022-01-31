import UIKit

class SecondsTimer: ObservableObject {
    var timer: Timer?
    var timerPaused = true
    @Published var seconds = 0

    init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    deinit {
        print("SecondsTimer deinit")
    }

    func start() {
        reset()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSeconds), userInfo: nil, repeats: true)
        timerPaused = false
    }

    func pause() { timerPaused = true }
    func resume() { timerPaused = false }
    func reset() { seconds = 0 }

    @objc private func updateSeconds() {
        guard !timerPaused else { return }
        seconds += 1
    }

    @objc private func appMovedToBackground() {
        pause()
    }

    @objc private func appMovedToForeground() {
        resume()
    }
}
