import Foundation

enum PuzzleDifficultyLevel: Int {

    case easy, medium, hard, evil

    static func level(count: Int) -> PuzzleDifficultyLevel {
        switch count {
            case 36:
                return .easy
            case 33:
                return .medium
            case 30:
                return .hard
            case 27:
                return .evil
            default:
                fatalError("Invalid puzzle.")
        }
    }

}

extension PuzzleDifficultyLevel: CustomStringConvertible {
    var description: String {
        switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
            case .evil:
                return "Evil"
        }
    }
}
