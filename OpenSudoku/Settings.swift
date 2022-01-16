import SwiftUI

class Settings: ObservableObject {
    @AppStorage("showIncorrect") var showIncorrect: Bool = true
    @AppStorage("completeLastNumber") var completeLastNumber: Bool = true
    @AppStorage("useSound") var useSound: Bool = true
    @AppStorage("useColor") var useColor: Bool = false
    @AppStorage("difficultyLevel") var difficultyLevel: Int = 0
}
