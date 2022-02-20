import Foundation

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
