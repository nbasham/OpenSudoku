import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @State var sliderValue: Double = 0
    private var levels = ["Easy", "Medium", "Hard", "Evil"]
    @State private var level = "Easy"

    var body: some View {
        Form {
            Section(header: Text("SETTINGS")) {
                Toggle("Show incorrect", isOn: $settings.showIncorrect)
                Toggle("Use sound", isOn: $settings.useSound)
                Toggle("Show timer", isOn: $settings.showTimer)
                Toggle("Auto complete last number", isOn: $settings.completeLastNumber)
                Toggle("Use color", isOn: $settings.useColor)
            }
            Section(header: Text("DIFFICULTY LEVEL")) {
                difficultyLevelView
            }
            Section(header: Text("DEBUG")) {
                HStack {
                    Text("Almost solve")
                    Spacer()
                    almostSolveButton
                }
            }
        }
    }

    private var difficultyLevelView: some View {
        VStack {
            Picker("Difficulty level", selection: $level) {
                ForEach(levels, id: \.self) {
                    Text($0)
                }
                .onChange(of: level) { value in
                    if let levelValue = levels.firstIndex(of: value),
                       let levelEnum = PuzzleDifficultyLevel(rawValue: levelValue) {
                        settings.difficultyLevel = levelEnum
                    }
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    private var almostSolveButton: some View {
        Button {
            PlayerAction.almostSolve.send()
        } label: {
            Image(systemName: "square.grid.3x3.fill")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preview()
    }
}
