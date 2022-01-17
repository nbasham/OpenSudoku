import XCTest
import Combine
@testable import OpenSudoku

class SudokuModelTests: XCTestCase {
    static private let unitTestPuzzleData = "4,2,1,18,3,5,6,7,8,9,7,17,1,6,4,12,11,5,3,5,15,17,7,11,18,1,13,7,8,3,4,10,18,14,15,2,11,6,13,5,8,7,1,3,9,1,9,5,6,2,12,4,8,16,8,4,7,3,18,10,2,5,15,5,12,2,16,4,15,17,18,10,15,10,9,2,5,17,7,4,12"
    private let puzzles = TestPuzzleSource.stringToPuzzle(unitTestPuzzleData)

    func testLastNumberIndexes() throws {
        var count = 0
        let puzzleSource: PuzzleSource = TestPuzzleSource()
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next(level: .easy))
        XCTAssertNil(model.lastNumberIndexes)
        for index in 0..<81 {
            let isClue = model.cells[index].isClue
            if isClue { continue }
            if model.answer(at: index) != 4 {
                model.guess(index, value: model.answer(at: index))
            } else {
                count += 1
            }
        }
        XCTAssertEqual(count, model.lastNumberIndexes?.count)
    }

    func testMark() throws {
        let model = SudokuCells()
        model.startGame(puzzle: puzzles)
        XCTAssertFalse(model.cells[79].isClue)
        let conflictIndexes = [1,2,3,6,8,9]
        for number in 1...9 {
            if conflictIndexes.contains(number) {
                XCTAssertTrue(model.isConflict(79, value: number))
            } else {
                XCTAssertFalse(model.isConflict(79, value: number))
            }
        }
        XCTAssertFalse(model.cells[0].markers[0])
        model.mark(0, number: 1)
        XCTAssertTrue(model.cells[0].markers[0])
        model.mark(0, number: 1)
        XCTAssertFalse(model.cells[0].markers[0])
    }

    func testIsSolved() throws {
        let model = SudokuCells()
        model.startGame(puzzle: puzzles)
        XCTAssertFalse(model.isSolved)
        for index in 0..<79 {
            let isClue = model.cells[index].isClue
            if !isClue {
                model.guess(index, value: model.answer(at: index))
            }
        }
        XCTAssertFalse(model.isSolved)
        model.guess(79, value: model.answer(at: 79))
        XCTAssertTrue(model.isSolved)
    }

    func testIsConflics() throws {
        let model = SudokuCells()
        model.startGame(puzzle: puzzles)
        model.guess(0, value: 9)
        XCTAssertTrue(model.isConflict(0, value: 9))
        model.guess(0, value: 4)
        XCTAssertFalse(model.isConflict(0, value: 4))
        XCTAssertFalse(model.isConflict(0, value: 3))
    }

    func testCorrect() throws {
        let model = SudokuCells()
        model.startGame(puzzle: puzzles)
        model.guess(0, value: 1)
        XCTAssertFalse(model.cells[0].isCorrect)
        model.guess(0, value: model.answer(at: 0))
        XCTAssertTrue(model.cells[0].isCorrect)
    }

    func testToggle() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource()
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next(level: .easy))
        model.guess(0, value: 1)
        XCTAssertEqual(1, model.cells[0].value)
        model.guess(0, value: 1)
        XCTAssertEqual(nil, model.cells[0].value)
        model.guess(0, value: 1)
        XCTAssertEqual(1, model.cells[0].value)
    }

    func testFirstUnguessedIndex() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource()
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next(level: .easy))
        XCTAssertEqual(0, model.firstUnguessedIndex!)
        for index in 0..<9 {
            let isClue = model.cells[index].isClue
            if !isClue {
                model.guess(index, value: model.answer(at: index))
            }
        }
        XCTAssertTrue(model.firstUnguessedIndex! > 9)
    }

    func testFirstUnguessedIndex2() throws {
        let model = SudokuCells()
        model.startGame(puzzle: puzzles)
        for index in 0..<79 {
            let isClue = model.cells[index].isClue
            if !isClue {
                model.guess(index, value: model.answer(at: index))
            }
        }
        XCTAssertEqual(79, model.firstUnguessedIndex!)
    }

    func testClues() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource()
        let puzzle = puzzleSource.next(level: .easy)
        let model = SudokuCells()
        model.startGame(puzzle: puzzle)
        for index in 0..<81 {
            let isClue = model.cells[index].isClue
            XCTAssertEqual(isClue, puzzle[index] > 9)
        }
    }

    func testGuesses() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource()
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next(level: .easy))
        for index in 0..<81 {
            let isClue = model.cells[index].isClue
            if !isClue {
                model.guess(index, value: 1)
            }
        }
        for index in 0..<81 {
            let isClue = model.cells[index].isClue
            if isClue { continue }
            if let value = model.cells[index].value {
                XCTAssertEqual(1, value)
            }
        }
    }
}
