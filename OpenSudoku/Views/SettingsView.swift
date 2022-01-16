import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @State var sliderValue: Double = 0

    var body: some View {
        Form {
            Section(header: Text("SETTINGS")) {
                Toggle("Show incorrect", isOn: $settings.showIncorrect)
                Toggle("Use sound", isOn: $settings.useSound)
                Toggle("Auto complete last number", isOn: $settings.completeLastNumber)
                Toggle("Use color", isOn: $settings.useColor)
            }
            Section(header: Text("DIFFICULTY LEVEL")) {
                VStack {
                    Text(PuzzleDifficultyLevel(rawValue: Int(sliderValue))!.description)
                    HStack {
                        Text("Easy")
                            .foregroundColor(.secondary)
                        Slider(value: $sliderValue, in: 0...3, step: 1) { _ in
                            settings.difficultyLevel = PuzzleDifficultyLevel(rawValue: Int(sliderValue))!
                        }
                        .onAppear {
                            self.sliderValue = Double(settings.difficultyLevel.rawValue)
                        }
                        Text("Evil")
                            .foregroundColor(.secondary)
                    }
                }
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
    }
}
