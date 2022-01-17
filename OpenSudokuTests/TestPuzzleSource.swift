import Foundation
@testable import OpenSudoku

class TestPuzzleSource: PuzzleSource, PuzzleIteratorSource {
    lazy var easyPuzzles: [String] = Bundle(for: type(of: self)).decode([String].self, from: "test_puzzles_easy.json")
    lazy var mediumPuzzles: [String] = Bundle(for: type(of: self)).decode([String].self, from: "test_puzzles_medium.json")
    lazy var hardPuzzles: [String] = Bundle(for: type(of: self)).decode([String].self, from: "test_puzzles_hard.json")
    lazy var evilPuzzles: [String] = Bundle(for: type(of: self)).decode([String].self, from: "test_puzzles_evil.json")

    func indexKey(for level: PuzzleDifficultyLevel) -> String {
        switch level {
            case .easy:
                return "test_puzzles_easy_key"
            case .medium:
                return "test_puzzles_medium_key"
            case .hard:
                return "test_puzzles_hard_key"
            case .evil:
                return "test_puzzles_evil_key"
        }
    }

    func puzzles(for level: PuzzleDifficultyLevel) -> [String] {
        switch level {
            case .easy:
                return easyPuzzles
            case .medium:
                return mediumPuzzles
            case .hard:
                return hardPuzzles
            case .evil:
                return evilPuzzles
        }
    }
}
