import Foundation
import Combine

class SudokuCells: ObservableObject {
    @Published var cells: [CellModel]
    @Published var usage: [[Bool]] = Array(repeating: Array(repeating: false, count: 9), count: 9)
    private var answers: [Int]
    private var guesses: [Int?]

    init() {
        cells = []
        answers = Array(repeating: 0, count: 81)
        guesses = Array(repeating: nil, count: 81)
    }

    func startGame(puzzle: [Int]) {
        answers = puzzle
        guesses = Array(repeating: nil, count: 81)
        calc()
    }

    func calc() {
        cells = (0..<81).map { value($0) }
        calcUsage()
    }

    func undo(guesses: [Int?]) {
        self.guesses = guesses
        calc()
    }

    func guess(_ index: Int, value: Int) {
        guard !isClue(index) else { fatalError("Can't set a value on a clue.") }
        if guesses[index] == value {
            guesses[index] = nil
        } else {
            removeValuesFromGrid(index, value)
            guesses[index] = value
        }
        calc()
    }
    var undoState: [Int?] { return guesses }
    var debugAnswers: [Int] { return answers }
}

extension SudokuCells {
    var firstUnguessedIndex: Int? {
        var index = 0
        while isClue(index) || guesses[index] != nil {
            index += 1
            guard index < 81 else { return nil }
        }
        return index
    }

    var lastUnguessedIndex: Int? {
        (0...80).last(where: { guesses[$0] == nil })
    }

    /// If there are no incorrect answers and all of the unanswered cells are the same number, return their indexes.
    var lastNumberIndexes: [Int]? {
        guard !hasIncorrectGuess else { return nil }
        guard let firstUnguessedIndex = firstUnguessedIndex else { return nil }
        let answerOfFirstUnguessedCell = answers[firstUnguessedIndex]
        var result: [Int] = []
        for i in 0...80 {
            if isClue(i) { continue }
            if guesses[i] == nil && answers[i] == answerOfFirstUnguessedCell {
                result.append(i)
            } else if guesses[i] == nil && answers[i] != answerOfFirstUnguessedCell {
                return nil
            }
        }
        guard !result.isEmpty else { return nil }
        return result
    }

    private func calcUsage() {
        var localUsage = Array(repeating: Array(repeating: false, count: 9), count: 9)
        var index = 0
        for cell in cells {
            if let value = cell.value {
                let gridIndex = SudokuConstants.indexToGrid(index)
                localUsage[value-1][gridIndex] = true
            }
            index += 1
        }
        usage = localUsage
    }

    var isSolved: Bool {
        for i in 0...80 {
            if isClue(i) { continue }
            if answers[i] != guesses[i] { return false }
        }
        return true
    }
}

private extension SudokuCells {

    func value(_ index: Int) -> CellModel {
        CellModel(isClue: isClue(index), value: displayValue(index), isCorrect: isCorrect(index), conflicts: isConflict(index, value: displayValue(index)))
    }

    func isClue(_ index: Int) -> Bool {
        answers[index] > 9
    }

    func isGuess(_ index: Int) -> Bool {
        !isClue(index)
    }

    func isCorrect(_ index: Int) -> Bool {
        guard isGuess(index) else { return true }
        return answers[index] == guesses[index]
    }

    func isConflict(_ index: Int, value: Int?) -> Bool {
        guard let value = value else { return false }
        for indexes in [SudokuConstants.rowIndexes(index),
                        SudokuConstants.colIndexes(index),
                        SudokuConstants.gridIndexes(index)] {
            let unique = indexes.filter { $0 != index }.allSatisfy { displayValue($0) != value }
            if unique == false {
                return true
            }
        }
        return false
    }

    func displayValue(_ index: Int) -> Int? {
        if isClue(index) {
            return answers[index] - 9
        } else {
            return guesses[index]
        }
    }

    /// When a guess is made remove other equal values from the current grid if the other values are incorrect.
    func removeValuesFromGrid(_ index: Int, _ value: Int) {
        let gridIndex = SudokuConstants.indexToGrid(index)
        let gridIndexes = SudokuConstants.GRIDINDEXES[gridIndex]
        for j in gridIndexes {
            if index == j { continue }
            if isClue(j) { continue }
            if value == displayValue(j) {
                if answers[j] != displayValue(j) {
                    guesses[j] = nil
                }
            }
        }
    }

    var hasIncorrectGuess: Bool {
        !guesses.enumerated().allSatisfy { $1 == nil || $1 == answers[$0]}
    }
}
