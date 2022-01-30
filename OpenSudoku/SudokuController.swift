import Foundation
import Combine

enum AnimationType {
    case completed(Int, Bool)
}
enum GameEvent {
    case solved
}
class SudokuController: ObservableObject {
    let model = SudokuCells()
    @Published var viewModel = [CellViewModel]()
    @Published var settings = Settings()
    @Published var selectedIndex = 0
    @Published var highlightedNumber: Int? = nil
    @Published var showSettings = false
    let animationPublisher = PassthroughSubject<AnimationType, Never>()
    private let puzzleSource: PuzzleSource = FilePuzzleSource()
    private var subscriptions = Set<AnyCancellable>()
    private var undoManager: UndoHistory<UndoState>?
    let eventPublisher = PassthroughSubject<GameEvent, Never>()
    private var undoState: UndoState {
        UndoState(selectedIndex: selectedIndex, highlightedNumber: highlightedNumber, guesses: model.undoState.1, markers: model.undoState.0)
    }

    init() {
        setupBindings()
    }

    func startGame() {
        model.startGame(puzzle: puzzleSource.next(level: settings.difficultyLevel))
        selectedIndex = model.firstUnguessedIndex ?? 0
        undoManager = UndoHistory(initialValue: undoState)
    }
}

private extension SudokuController {
    private func almostSolve() {
        if let lastIndex = model.lastUnguessedIndex {
            for index in 0..<lastIndex-1 {
                let isClue = model.cells[index].isClue
                if !isClue && model.answer(at: index) != 5 {
                    model.guess(index, value: model.answer(at: index))
                }
            }
            selectedIndex = lastIndex - 1
            highlightedNumber = model.answer(at: selectedIndex)
        }
    }

    private func setupBindings() {
        model.$cells
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] obj in
                self?.calcViewModel()
            }
            .store(in: &subscriptions)

        settings.$difficultyLevel
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] obj in
                self?.startGame()
            }
            .store(in: &subscriptions)

        let center = NotificationCenter.default

        center.publisher(for: PlayerAction.numberGuess, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { [weak self] number in
                guard let self = self else { return }
                self.handleGuess(number: number)
            }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.markerGuess, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { [weak self] number in
                guard let self = self else { return }
                self.handleMark(number: number)
            }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.cellTap, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { [weak self] index in
                self?.handleCellTap(index)
           }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.undo, object: nil)
            .sink { _ in self.undo() }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.showSettings, object: nil)
            .sink { _ in self.showSettings = true }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.settingsDismiss, object: nil)
            .sink { _ in self.handleSettingsDismiss() }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.almostSolve, object: nil)
            .sink { _ in self.almostSolve() }
            .store(in: &subscriptions)

        center.publisher(for: PlayerAction.usageTap, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { number in
                self.handleUsageTap(number: number)
            }
            .store(in: &subscriptions)
    }

    private func calcViewModel() {
        viewModel = model.cells.enumerated().map { CellViewModel(id: $0, model: $1, cellMarkers: model.markers[$0], isConflict: model.isConflict, selectedIndex: selectedIndex, highlightedNumber: highlightedNumber, showIncorrect: settings.showIncorrect) }
    }

    private func handleUsageTap(number: Int) {
        highlightedNumber = number
        calcViewModel()
    }

    private func handleSettingsDismiss() {
        calcViewModel()
        //  TODO I don't think we need this event
    }

    private func handleMark(number: Int) {
        model.mark(selectedIndex, number: number)
        undoManager?.currentItem = undoState
    }

    private func handleGuess(number: Int) {
        model.guess(selectedIndex, value: number, showIncorrect: settings.showIncorrect)
        undoManager?.currentItem = undoState
        if model.isSolved {
            eventPublisher.send(.solved)
        } else {
            completed(index: selectedIndex, number: number)
        }
    }

    var shouldAutofill: Bool {
        settings.completeLastNumber && model.onlyOneNumberRemains
    }

    private func handleCellTap(_ index: Int) {
        if model.cells[index].isClue || model.cells[index].isCorrect {
            if model.cells[index].value == highlightedNumber {
                highlightedNumber = nil
            } else {
                highlightedNumber = model.cells[index].value
            }
        } else {
            selectedIndex = index
        }
        calcViewModel()
        undoManager?.currentItem = undoState
    }

    private func undo() {
        undoManager?.undo()
        if let item = undoManager?.currentItem {
            selectedIndex = item.selectedIndex
            highlightedNumber = item.highlightedNumber
            model.undo(markers: item.markers, guesses: item.guesses)
            calcViewModel()
        }
    }

    //  Check if we should autofill the last number, if not, check if row, col, and or grid should be animated
    private func completed(index: Int, number: Int) {
        if shouldAutofill {
            if let indexes = model.lastNumberIndexes {
                let lastNumber = model.answer(at: indexes[0])
                print("lastNumber \(lastNumber)")
                print(indexes)
                indexes.forEachAfter { i in
                    self.model.guess(i, value: lastNumber)
                }
                animateLastNumber(indexes, number: lastNumber) {
                    self.eventPublisher.send(.solved)
                }
                return
            }
        }

        if model.isRowComplete(for: index) {
            animateCompletion(SudokuConstants.rowIndexes(index))
        }

        if model.isColComplete(for: index) {
            animateCompletion(SudokuConstants.colIndexes(index))
        }

        if model.isGridComplete(for: index) {
            animateCompletion(SudokuConstants.gridIndexes(index))
        }

        let indexes = model.indexes(for: number)
        if indexes.count == 9 {
            animateCompletion(indexes) {
                if self.highlightedNumber == number {
                    self.highlightedNumber = nil
                }
                self.calcViewModel()
            }
        }
    }

    private func animateLastNumber(_ indexes: [Int], number: Int, completion: (() -> ())? = nil) {
        indexes.forEachAfter { index in
            self.animationPublisher.send(.completed(index, true))
        }
        indexes.forEachAfter(startTime: 0.5) { index in
            self.animationPublisher.send(.completed(index, false))
        } completion: {
            completion?()
        }
    }

    private func animateCompletion(_ indexes: [Int], completion: (() -> ())? = nil) {
        indexes.forEachAfter { index in
            self.animationPublisher.send(.completed(index, true))
        }
        indexes.forEachAfter(startTime: 0.5) { index in
            self.animationPublisher.send(.completed(index, false))
        } completion: {
            completion?()
        }
    }
}

extension Array where Element == Int {
    // For each element in a collection perform a task after a linearly increasing interval
    func forEachAfter(interval: Double = 0.1, startTime: Double = 0, task: @escaping (Int) -> (), completion: (() -> ())? = nil) {
        for i in 0..<self.count {
            let currInterval: Double = Double(i) * interval
            DispatchQueue.main.asyncAfter(deadline: .now() + currInterval + startTime) { [i = i, value = self[i]] in
                task(value)
                let isLast = i == (self.count-1)
                if isLast {
                    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                        completion?()
                    }
                }
           }
        }
    }
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
    static let undo = Notification.Name("ui_undo")
    static let showSettings = Notification.Name("ui_showSettings")
    static let settingsDismiss = Notification.Name("ui_settingsDismiss")
    static let usageTap = Notification.Name("ui_usageTap")
    static let almostSolve = Notification.Name("ui_almostSolve")
}
