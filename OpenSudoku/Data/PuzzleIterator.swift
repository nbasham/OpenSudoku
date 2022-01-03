import SwiftUI

/// Returns the next puzzle as  an `[Int]` for the difficulty level specified by  `setLevel(PuzzleDifficultyLevel)`. By convention the `[Int]` will contain values 1 to 9 for non clue values and 10 to 18 for clues.
class PuzzleIterator: IteratorProtocol {

    func setLevel(level: PuzzleDifficultyLevel) { self.level = level }

    func next() -> String? {
        let levelPuzzles = puzzles(level)
        let key = puzzleIndexKey(level)
        var index = UserDefaults.standard.integer(forKey: key)
        defer {
            if index < levelPuzzles.count-1 {
                index += 1
            } else {
                index = 0
            }
        }
        UserDefaults.standard.set(index, forKey: key)
        return levelPuzzles[index]
    }

    //  Private
    private var level: PuzzleDifficultyLevel = .easy
    lazy private var easyPuzzles: [String] = Bundle.main.decode([String].self, from: "puzzles_easy.json")
    lazy private var mediumPuzzles: [String] = Bundle.main.decode([String].self, from: "puzzles_medium.json")
    lazy private var hardPuzzles: [String] = Bundle.main.decode([String].self, from: "puzzles_hard.json")
    lazy private var evilPuzzles: [String] = Bundle.main.decode([String].self, from: "puzzles_evil.json")

    private func puzzleIndexKey(_ level: PuzzleDifficultyLevel) -> String {
        switch level {
            case .easy:
                return "puzzles_easy_key"
            case .medium:
                return "puzzles_medium_key"
            case .hard:
                return "puzzles_hard_key"
            case .evil:
                return "puzzles_evil_key"
        }
    }

    private func puzzles(_ level: PuzzleDifficultyLevel) -> [String] {
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
