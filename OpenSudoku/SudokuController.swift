import Foundation
import Combine

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
        //  TODO InfoView not updated with new level
    }

    private func handleMark(number: Int) {
        model.mark(selectedIndex, number: number)
        undoManager?.currentItem = undoState
    }

    private func handleGuess(number: Int) {
        model.guess(selectedIndex, value: number)
        undoManager?.currentItem = undoState
        if model.isSolved {
            eventPublisher.send(.solved)
        } else if settings.completeLastNumber {
            if let lastIndexes = model.lastNumberIndexes {
                autofillLastNumber(lastIndexes)
            }
        }
    }

    private func autofillLastNumber(_ lastIndexes: [Int]) {
        var count: Double = 1
        let sortedLastIndexes = lastIndexes.sorted { lhs, rhs in
            SudokuConstants.indexToGrid(lhs) < SudokuConstants.indexToGrid(rhs)
        }
        let lastNumber = model.answer(at: sortedLastIndexes[0])
        let duration = 0.5
        highlightedNumber = lastNumber
        for index in sortedLastIndexes {
            DispatchQueue.main.asyncAfter(deadline: .now() + count) { [index = index] in
                self.model.guess(index, value: lastNumber)
            }
            count += duration
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(sortedLastIndexes.count)*duration + 1.0) {
            self.eventPublisher.send(.solved)
        }
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
