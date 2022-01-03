import Foundation
import Combine

enum GameEvent {
    case solved
}
class SudokuController: ObservableObject {
    let model = SudokuCells()
    @Published var viewModel = [CellViewModel]()
    @Published var selectedIndex = 0
    @Published var highlightedNumber: Int? = nil
    private let puzzleSource: PuzzleSource = TestPuzzleSource()
    private var subscriptions = Set<AnyCancellable>()
    private var undoManager: UndoHistory<UndoState>?
    let eventPublisher = PassthroughSubject<GameEvent, Never>()
    private var undoState: UndoState {
        UndoState(selectedIndex: selectedIndex, highlightedNumber: highlightedNumber, guesses: model.undoState)
    }

    init() {
        setupBindings()
    }

    func startGame() {
        model.startGame(puzzle: puzzleSource.next())
        selectedIndex = model.firstUnguessedIndex ?? 0
        undoManager = UndoHistory(initialValue: undoState)
    }
}

private extension SudokuController {
    private func almostSolve() {
        if let lastIndex = model.lastUnguessedIndex {
            for index in 0..<lastIndex-1 {
                let isClue = model.cells[index].isClue
                if !isClue {
                    model.guess(index, value: model.debugAnswers[index])
                }
            }
            selectedIndex = lastIndex - 1
            highlightedNumber = model.debugAnswers[lastIndex - 1]
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

        let center = NotificationCenter.default

        center.publisher(for: PlayerAction.numberGuess, object: nil)
            .map({ ($0.object as! NSNumber).intValue })
            .sink { [weak self] number in
                guard let self = self else { return }
                self.handleGuess(number: number)
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

        center.publisher(for: PlayerAction.almostSolve, object: nil)
            .sink { _ in self.almostSolve() }
            .store(in: &subscriptions)
    }

    private func calcViewModel() {
        viewModel = model.cells.enumerated().map { CellViewModel(id: $0, model: $1, selectedIndex: selectedIndex, highlightedNumber: highlightedNumber) }
    }

    private func handleGuess(number: Int) {
        model.guess(selectedIndex, value: number)
        undoManager?.currentItem = undoState
        if model.isSolved {
            eventPublisher.send(.solved)
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
            model.undo(guesses: item.guesses)
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
    static let cellTap = Notification.Name("ui_cellTap")
    static let undo = Notification.Name("ui_undo")
    static let almostSolve = Notification.Name("ui_almostSolve")
}
