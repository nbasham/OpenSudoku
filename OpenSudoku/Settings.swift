import SwiftUI

class Settings: ObservableObject {
    @AppStorage("showIncorrect") var showIncorrect: Bool = true
    @AppStorage("completeLastNumber") var completeLastNumber: Bool = true
    @AppStorage("useSound") var useSound: Bool = true
    @AppStorage("useColor") var useColor: Bool = false
    @Published var difficultyLevel: PuzzleDifficultyLevel  {
        didSet {
            objectWillChange.send()
            UserDefaults.standard.set(difficultyLevel.rawValue, forKey: "difficultyLevel")
        }
    }

    init() {
        let level = UserDefaults.standard.integer(forKey: "difficultyLevel")
        difficultyLevel = PuzzleDifficultyLevel(rawValue: level) ?? .easy
    }
}
