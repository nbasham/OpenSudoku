import XCTest
import Combine
@testable import OpenSudoku

class SudokuModelTests: XCTestCase {
    //  swiftlint:disable:next line_length
    public let unitTestPuzzleData = "4,2,1,18,3,5,6,7,8,9,7,17,1,6,4,12,11,5,3,5,15,17,7,11,18,1,13,7,8,3,4,10,18,14,15,2,11,6,13,5,8,7,1,3,9,1,9,5,6,2,12,4,8,16,8,4,7,3,18,10,2,5,15,5,12,2,16,4,15,17,18,10,15,10,9,2,5,17,7,4,12"

    func testLastNumberIndexes() throws {
        var count = 0
        let puzzleSource: PuzzleSource = TestPuzzleSource(puzzle: unitTestPuzzleData)
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next())
        XCTAssertNil(model.lastNumberIndexes)
        for index in 0..<81 {
            let isClue = model.cells[index].isClue
            if isClue { continue }
            if model.debugAnswers[index] != 4 {
                model.guess(index, value: model.debugAnswers[index])
            } else {
                count += 1
            }
        }
        XCTAssertEqual(count, model.lastNumberIndexes?.count)
    }

    func testIsSolved() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource(puzzle: unitTestPuzzleData)
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next())
        XCTAssertFalse(model.isSolved)
        for index in 0..<79 {
            let isClue = model.cells[index].isClue
            if !isClue {
                model.guess(index, value: model.debugAnswers[index])
            }
        }
        XCTAssertFalse(model.isSolved)
        model.guess(79, value: model.debugAnswers[79])
        XCTAssertTrue(model.isSolved)
    }

    func testIsConflics() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource(puzzle: unitTestPuzzleData)
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next())
        model.guess(0, value: 9)
        XCTAssertTrue(model.cells[0].conflicts)
        model.guess(0, value: 4)
        XCTAssertFalse(model.cells[0].conflicts)
    }

    func testCorrect() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource(puzzle: unitTestPuzzleData)
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next())
        model.guess(0, value: 1)
        XCTAssertFalse(model.cells[0].isCorrect)
        model.guess(0, value: 4)
        XCTAssertTrue(model.cells[0].isCorrect)
    }

    func testToggle() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource(puzzle: unitTestPuzzleData)
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next())
        model.guess(0, value: 1)
        XCTAssertEqual(1, model.cells[0].value)
        model.guess(0, value: 1)
        XCTAssertEqual(nil, model.cells[0].value)
        model.guess(0, value: 1)
        XCTAssertEqual(1, model.cells[0].value)
    }

    func testFirstUnguessedIndex() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource(puzzle: unitTestPuzzleData)
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next())
        XCTAssertEqual(0, model.firstUnguessedIndex!)
        model.guess(0, value: 4)
        model.guess(1, value: 2)
        model.guess(2, value: 1)
        XCTAssertEqual(4, model.firstUnguessedIndex!)
    }

    func testFirstUnguessedIndex2() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource(puzzle: unitTestPuzzleData)
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next())
        for index in 0..<79 {
            let isClue = model.cells[index].isClue
            if !isClue {
                model.guess(index, value: model.debugAnswers[index])
            }
        }
        XCTAssertEqual(79, model.firstUnguessedIndex!)
    }

    func testClues() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource(puzzle: unitTestPuzzleData)
        let puzzle = puzzleSource.next()
        let model = SudokuCells()
        model.startGame(puzzle: puzzle)
        for index in 0..<81 {
            let isClue = model.cells[index].isClue
            XCTAssertEqual(isClue, puzzle[index] > 9)
        }
    }

    func testGuesses() throws {
        let puzzleSource: PuzzleSource = TestPuzzleSource(puzzle: unitTestPuzzleData)
        let model = SudokuCells()
        model.startGame(puzzle: puzzleSource.next())
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
