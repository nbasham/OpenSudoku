import SwiftUI

/// Returns the next puzzle as  an `[Int]` for the difficulty level specified by  `setLevel(PuzzleDifficultyLevel)`. By convention the `[Int]` will contain values 1 to 9 for non clue values and 10 to 18 for clues.
class PuzzleIterator: IteratorProtocol {
    let puzzles: [String]
    let key: String

    init(puzzles: [String], key: String) {
        self.puzzles = puzzles
        self.key = key
    }

    func next() -> String? {
        var index = UserDefaults.standard.integer(forKey: key)
        defer {
            if index < puzzles.count-1 {
                index += 1
            } else {
                index = 0
            }
            UserDefaults.standard.set(index, forKey: key)
        }
        return puzzles[index]
    }
}
