import Foundation

protocol PuzzleSource {
    func next(level: PuzzleDifficultyLevel) -> [Int]
}

protocol PuzzleIteratorSource {
    func indexKey(for level: PuzzleDifficultyLevel) -> String
    func puzzles(for level: PuzzleDifficultyLevel) -> [String]
}

extension PuzzleIteratorSource {
    func next(level: PuzzleDifficultyLevel) -> [Int] {
        let key = indexKey(for: level)
        let puzzles = puzzles(for: level)
        print("Iterator for key \(key) level \(level)")
        let iterator = PuzzleIterator(puzzles: puzzles, key: key)
        guard let puzzleString = iterator.next() else { fatalError() }
        return Self.stringToPuzzle(puzzleString)
    }
    static func stringToPuzzle(_ string: String) -> [Int] {
        string.split(separator: ",").map { String($0) }.map { Int($0)! }
    }
}

class FilePuzzleSource: PuzzleSource, PuzzleIteratorSource {
    func indexKey(for level: PuzzleDifficultyLevel) -> String {
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

    lazy var easyPuzzles: [String] = Bundle.main.decode([String].self, from: "puzzles_easy.json")
    lazy var mediumPuzzles: [String] = Bundle.main.decode([String].self, from: "puzzles_medium.json")
    lazy var hardPuzzles: [String] = Bundle.main.decode([String].self, from: "puzzles_hard.json")
    lazy var evilPuzzles: [String] = Bundle.main.decode([String].self, from: "puzzles_evil.json")

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
