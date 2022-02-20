import Foundation

typealias Scores = [ScoreModel]

extension Scores {

    static func add(_ score: ScoreModel, level: PuzzleDifficultyLevel, storage: UserDefaults = UserDefaults.standard) {
        var scores = Scores.load(level: level, storage: storage)
        scores.append(score)
        Scores.save(scores: scores, level: level, storage: storage)
    }

    static func clear(level: PuzzleDifficultyLevel, storage: UserDefaults = UserDefaults.standard) {
        Scores.save(scores: [], level: level, storage: storage)
    }

    static private func save(scores: Scores, level: PuzzleDifficultyLevel, storage: UserDefaults = UserDefaults.standard) {
        print("Saving \(scores.count) scores for \(level.description).")
        if let data = try? JSONEncoder().encode(scores) {
            storage.setValue(data, forKey: key(level))
        }
    }

    static func load(level: PuzzleDifficultyLevel, storage: UserDefaults = UserDefaults.standard) -> [ScoreModel] {
        if let data = storage.data(forKey: key(level)),
           let loadedScores =  try? JSONDecoder().decode(Scores.self, from: data) {
            print("Loaded \(loadedScores.count) scores for \(level.description).")
            return loadedScores
        }
        print("Loaded 0 scores for \(level.description).")
        return []
    }

    private static func key(_ level: PuzzleDifficultyLevel) -> String {
        "scores_\(level.description.lowercased())"
    }
}

extension Array where Element == ScoreModel {
    var average: Double {
        guard count > 0 else { return 0 }
        return self.map { Double($0.score) }.reduce(0, +) / Double(count)
    }

    func top(count: Int) -> [ScoreModel] {
        Array(self.sorted().prefix(count))
    }

    func recent(count: Int) -> [ScoreModel] {
        Array(self.sorted(by: { lhs, rhs in lhs.date > rhs.date }).prefix(count))
    }

    var mostRecent: ScoreModel? {
        Array(self.sorted(by: { lhs, rhs in lhs.date > rhs.date })).first
    }
}
