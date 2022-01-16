import XCTest
@testable import OpenSudoku

class PuzzleSourceTests: XCTestCase {

    func testIterator() throws {
        let iterator = PuzzleIterator()
        for level in PuzzleDifficultyLevel.allCases {
            iterator.setLevel(level: level)
            let string = iterator.next()!
            let puzzle = FilePuzzleSource.stringToPuzzle(string)
            let count = puzzle.filter { $0 > 9 }.count
            XCTAssertEqual(count, level.numClues)
        }
    }

    func testSource() throws {
        let puzzleSource: PuzzleSource = FilePuzzleSource()
        for level in PuzzleDifficultyLevel.allCases {
            let puzzle = puzzleSource.next(level: level)
            let count = puzzle.filter { $0 > 9 }.count
            XCTAssertEqual(count, level.numClues)
        }
    }
}
