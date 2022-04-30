import Foundation
import UIKit

struct ScoreModel: Codable, Comparable {
    let date: Date
    let seconds: Int
    let numIncorrect: Int
    let numRemaining: Int
    let usedColor: Bool
    var score: Int {
        max(0, 60 * 10 - seconds) -
        numIncorrect * 10 +
        numRemaining * 10
    }

    static func < (lhs: ScoreModel, rhs: ScoreModel) -> Bool {
        lhs.score > rhs.score
    }
}


struct ScoreViewModel: Identifiable, Hashable {
    let id: UUID
    let date: String
    let score: String
}

extension ScoreViewModel {
    static let scoreRelativeDateFormat: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    init(_ score: ScoreModel) {
        id = UUID()
        date = ScoreViewModel.scoreRelativeDateFormat.string(for: score.date) ?? score.date.formatted()
        self.score = "\(score.score)"
    }
}

class ScoresViewModel: ObservableObject {
    let scores: [ScoreViewModel]
    let recentScores: [ScoreViewModel]
    let topScores: [ScoreViewModel]
    let level: String
    let average: String
    let numGames: String

    private static func numScores() -> Int {
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight <= 667 {
            return 5
        } else if screenHeight <= 780 {
            return 6
        }
        return 7
    }

    init(scoreModels: [ScoreModel], level: PuzzleDifficultyLevel) {
        let count = ScoresViewModel.numScores()
        recentScores = scoreModels.recent(count: count).map { ScoreViewModel($0) }
        topScores = scoreModels.top(count: count).sorted().map { ScoreViewModel($0) }
        scores = scoreModels.sorted(by: { lhs, rhs in lhs.date > rhs.date }).map { ScoreViewModel($0) }
        self.level = level.description
        average = String(format: "%.2f", scoreModels.average)
        numGames = "\(scoreModels.count)"
    }
}
