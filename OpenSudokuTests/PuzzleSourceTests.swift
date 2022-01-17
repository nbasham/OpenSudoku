import XCTest
@testable import OpenSudoku

class PuzzleSourceTests: XCTestCase {

    func testValidate() throws {
        lazy var easyPuzzles: [String] = Bundle(for: type(of: self)).decode([String].self, from: "test_puzzles_easy.json")
        for string in easyPuzzles {
            let puzzle = TestPuzzleSource.stringToPuzzle(string)
            let count = puzzle.filter { $0 > 9 }.count
            XCTAssertEqual(count, 36)
        }
        lazy var mediumPuzzles: [String] = Bundle(for: type(of: self)).decode([String].self, from: "test_puzzles_medium.json")
        for string in mediumPuzzles {
            let puzzle = TestPuzzleSource.stringToPuzzle(string)
            let count = puzzle.filter { $0 > 9 }.count
            XCTAssertEqual(count, 33)
        }
        lazy var hardPuzzles: [String] = Bundle(for: type(of: self)).decode([String].self, from: "test_puzzles_hard.json")
        for string in hardPuzzles {
            let puzzle = TestPuzzleSource.stringToPuzzle(string)
            let count = puzzle.filter { $0 > 9 }.count
            XCTAssertEqual(count, 30)
        }
        lazy var evilPuzzles: [String] = Bundle(for: type(of: self)).decode([String].self, from: "test_puzzles_evil.json")
        for string in evilPuzzles {
            let puzzle = TestPuzzleSource.stringToPuzzle(string)
            let count = puzzle.filter { $0 > 9 }.count
            XCTAssertEqual(count, 27)
        }
    }
    func testSource() throws {
        UserDefaults.standard.set(0, forKey: "test_puzzles_easy_key")
        let settings = Settings()
        let source = TestPuzzleSource()
        for _ in 0...10 {
            for level in PuzzleDifficultyLevel.allCases {
                settings.difficultyLevel = level
                let puzzle = source.next(level: level)
                let count = puzzle.filter { $0 > 9 }.count
                XCTAssertEqual(count, level.numClues)
            }
        }
    }

    func testIteratorWrap() throws {
        let settings = Settings()
        settings.difficultyLevel = .easy
        let source = TestPuzzleSource()
        UserDefaults.standard.set(0, forKey: "test_puzzles_easy_key")
        let puzzle = source.next(level: .easy)
        for index in 1...2 {
            let p = source.next(level: .easy)
            XCTAssertNotEqual(puzzle, p)
            let p1 = source.puzzles(for: .easy)[index]
            XCTAssertEqual(p, TestPuzzleSource.stringToPuzzle(p1))
        }
        let firstPuzzle = source.next(level: .easy)
        XCTAssertEqual(puzzle, firstPuzzle)
    }
}
