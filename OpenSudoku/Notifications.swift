import Foundation
import Combine

enum AnimationType {
    case completed(Int, Bool, Double)
    case showAutoCompleting(Bool)
}

extension Notification.Name {
    func send(obj: Any? = nil) {
        NotificationCenter.default.post(name: self, object: obj)
    }
}

class PlayerAction: ObservableObject {
    let center = NotificationCenter.default
    static let numberGuess = Notification.Name("ui_numberGuess")
    static let markerGuess = Notification.Name("ui_markerGuess")
    static let cellTap = Notification.Name("ui_cellTap")
    static let cellDoubleTap = Notification.Name("ui_cellDoubleTap")
    static let undo = Notification.Name("ui_undo")
    static let showSettings = Notification.Name("ui_showSettings")
    static let hideScores = Notification.Name("ui_hideScores")
    static let settingsDismiss = Notification.Name("ui_settingsDismiss")
    static let usageTap = Notification.Name("ui_usageTap")
    static let almostSolve = Notification.Name("ui_almostSolve")
}

class Notifications {
    private var subscriptions = Set<AnyCancellable>()

    func setupNotifications(controller: SudokuController) {
        let center = NotificationCenter.default

        center.publisher(for: PlayerAction.numberGuess, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { number in
                controller.handleGuess(number: number)
            }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.markerGuess, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { number in
                controller.handleMark(number: number)
            }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.cellTap, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { index in
                controller.handleCellTap(index)
            }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.cellDoubleTap, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { number in
                controller.handleDoubleTap(number: number)
            }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.undo, object: nil)
            .sink { _ in controller.handleUndo() }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.showSettings, object: nil)
            .sink { _ in controller.showSettings = true }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.hideScores, object: nil)
            .sink { _ in controller.showScores = false }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.settingsDismiss, object: nil)
            .sink { _ in controller.handleSettingsDismiss() }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.almostSolve, object: nil)
            .sink { _ in controller.almostSolve() }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.usageTap, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { number in
                controller.handleUsageTap(number: number)
            }
            .store(in: &subscriptions)
    }
}
