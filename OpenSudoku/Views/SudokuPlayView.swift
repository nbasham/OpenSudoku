import SwiftUI

struct SudokuPlayView: View {
    @EnvironmentObject var ui: UI
    @EnvironmentObject var controller: SudokuController
    @Environment(\.pixelLength) var pixelLength: CGFloat
    @State private var showAutoCompleting = false

    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Spacer()
                Button {
                    PlayerAction.showSettings.send()
                } label: {
                    UI.settingsImage
                        .imageScale(.large)
                }
                .padding(.top)
                .padding(.trailing)
            }
            VStack {
                ZStack {
                    BoardView()
                    CellsView()
                    autoComplete
                }
                .padding(.horizontal, controller.settings.wideView ? 0 : 16)
                if !controller.isSolved {
                    InfoView()
                        .padding(.horizontal)
                }
            }
            if controller.isSolved {
                GameOverView()
            } else {
                MarkerPickerView()
                    .frame(minHeight: 36)
                    .padding(.horizontal)
                NumberPickerView()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
        .onReceive(controller.animationPublisher) { animationType in
            switch animationType {
                case let .showAutoCompleting(isShowing):
                    showAutoCompleting = isShowing
                default:
                    break
            }
        }
        .sheet(isPresented: $controller.showScores) {
            PlayerAction.hideScores.send()
        } content: {
            ScoresView()
                .environmentObject(controller.scores())
        }
        .sheet(isPresented: $controller.showSettings) {
            PlayerAction.settingsDismiss.send()
        } content: {
            SettingsView()
        }
        .accentColor(ui.gameAccentColor)
    }

    var autoComplete: some View {
        Text(ui.autoCompleteText(isShowing: showAutoCompleting))
                .font(ui.autoCompleteFont)
            .foregroundColor(ui.autoCompleteTextColor)
            .zIndex(Double.greatestFiniteMagnitude)
    }
}

struct SudokuView_Previews: PreviewProvider {
    static var previews: some View {
        SudokuPlayView()
            .preview()
    }
}
