import Foundation
import Combine
import SwiftUI // for Color

class SudokuController: ObservableObject {
    let model = SudokuCells()
    @Published var viewModel = [CellViewModel]()
    @Published var settings = Settings()
    @Published var selectedIndex = 0
    @Published var highlightedNumber: Int? = nil
    @Published var showSettings = false
    @Published var isSolved = false
    @Published var time = "00:00"
    var timer = SecondsTimer()
    let animationPublisher = PassthroughSubject<AnimationType, Never>()
    private let puzzleSource: PuzzleSource = FilePuzzleSource()
    private let notifications = Notifications()
    private var subscriptions = Set<AnyCancellable>()
    private var undoManager: UndoHistory<UndoState>?
    private var lastPick: LastPick?
    private var undoState: UndoState {
        UndoState(selectedIndex: selectedIndex, highlightedNumber: highlightedNumber, guesses: model.undoState.1, markers: model.undoState.0)
    }
    var autoCompleteTextColor: Color {
        let darkMode = UITraitCollection.current.userInterfaceStyle == .dark
        if settings.useColor {
            return darkMode ? .white : .black
        } else {
            return .accentColor
        }
    }

    init() {
        setupBindings()
        notifications.setupNotifications(controller: self)
    }

    func startGame() {
        isSolved = false
        model.startGame(puzzle: puzzleSource.next(level: settings.difficultyLevel))
        selectedIndex = model.firstUnguessedIndex ?? 0
        undoManager = UndoHistory(initialValue: undoState)
        timer.start()
    }
}

extension SudokuController {

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

        timer.$seconds
            .receive(on: RunLoop.main)
            .sink { [weak self] seconds in
                self?.time = seconds.timerValue
            }
            .store(in: &subscriptions)
    }

    private func calcViewModel() {
        viewModel = model.cells.enumerated().map { CellViewModel(id: $0, model: $1, cellMarkers: model.markers[$0], isConflict: model.isConflict, selectedIndex: selectedIndex, highlightedNumber: highlightedNumber, showIncorrect: settings.showIncorrect) }
    }

    private func handleSolved() {
        isSolved = true
        timer.pause()
    }

    func handleUsageTap(number: Int) {
        highlightedNumber = number
        lastPick = LastPick(number: number)
        calcViewModel()
    }

    func handleSettingsDismiss() {
        calcViewModel()
        //  TODO I don't think we need this event
    }

    func handleDoubleTap(number: Int) {
        guard let pick = self.lastPick else { return }
        if pick.isNumber {
            self.handleGuess(number: pick.number)
        } else {
            self.handleMark(number: pick.marker)
        }
    }

    func handleMark(number: Int) {
        model.mark(selectedIndex, number: number)
        lastPick = LastPick(marker: number)
        undoManager?.currentItem = undoState
    }

    func handleGuess(number: Int) {
        let isCorrect = model.guess(selectedIndex, value: number, showIncorrect: settings.showIncorrect)
        lastPick = LastPick(number: number)
        undoManager?.currentItem = undoState
        if model.isSolved {
            handleSolved()
        } else {
            if isCorrect || !settings.showIncorrect {
                completed(index: selectedIndex, number: number)
            }
        }
    }

    var shouldAutofill: Bool {
        settings.completeLastNumber && model.onlyOneNumberRemains
    }

    func handleCellTap(_ index: Int) {
        if model.cells[index].isClue || model.cells[index].isCorrect {
            setHightlightNumber(model.cells[index].value)
        } else {
            selectedIndex = index
        }
        calcViewModel()
        undoManager?.currentItem = undoState
    }

    private func setHightlightNumber(_ number: Int?) {
        if number == highlightedNumber {
            highlightedNumber = nil
            lastPick = nil
        } else {
            highlightedNumber = number
            if let number = number {
                lastPick = LastPick(number: number)
            }
        }
    }

    func almostSolve() {
        guard let last4Index = model.lastIndex(of: 4) else { return }
        let numberToSkip = 5
        for index in stride(from: 80, through: 0, by: -1) {
            let isClue = model.cells[index].isClue
            if isClue { continue }
            if last4Index == index { continue }
            if model.answer(at: index) != numberToSkip {
                model.guess(index, value: model.answer(at: index))
            }
        }
        selectedIndex = last4Index
        highlightedNumber = 4
    }

    func handleUndo() {
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
            highlightedNumber = nil
            calcViewModel()
            if let indexes = model.lastNumberIndexes {
                self.animationPublisher.send(.showAutoCompleting(true))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let lastNumber = self.model.answer(at: indexes[0])
                    indexes.forEachAfter { i in
                        self.model.guess(i, value: lastNumber)
                    }
                    self.animateLastNumber(indexes, number: lastNumber) {
                        self.animationPublisher.send(.showAutoCompleting(false))
                        self.handleSolved()
                    }
                }
                return
            }
        }

        var delay: Double = 0.0

        if model.isRowComplete(for: index) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.animateCompletion(SudokuConstants.rowIndexes(index))
            }
            delay += 1
        }

        if model.isColComplete(for: index) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.animateCompletion(SudokuConstants.colIndexes(index))
            }
            delay += 1
        }

        if model.isGridComplete(for: index) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.animateCompletion(SudokuConstants.gridIndexes(index))
            }
            delay += 1
        }

        let indexes = model.indexes(for: number)
        if indexes.count == 9 {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.animateCompletion(indexes) {
                    if self.highlightedNumber == number {
                        self.highlightedNumber = nil
                    }
                    self.lastPick = nil
                    self.calcViewModel()
                }
            }
        }
    }

    var maxAnimation: Double {
        settings.useColor ? 1.25 : 2.0
    }

    private func animateLastNumber(_ indexes: [Int], number: Int, completion: (() -> ())? = nil) {
        indexes.forEachAfter { index in
            self.animationPublisher.send(.completed(index, true, self.maxAnimation))
        }
        indexes.forEachAfter(startTime: 0.5) { index in
            self.animationPublisher.send(.completed(index, false, self.maxAnimation))
        } completion: {
            completion?()
        }
    }

    private func animateCompletion(_ indexes: [Int], completion: (() -> ())? = nil) {
        indexes.forEachAfter { index in
            self.animationPublisher.send(.completed(index, true, self.maxAnimation))
        }
        indexes.forEachAfter(startTime: 0.5) { index in
            self.animationPublisher.send(.completed(index, false, self.maxAnimation))
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
