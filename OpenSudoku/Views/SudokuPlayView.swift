import SwiftUI

struct SudokuPlayView: View {
    @EnvironmentObject var controller: SudokuController
    @Environment(\.pixelLength) var pixelLength: CGFloat
    private let boardColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 9)
    private let pickerColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    @State private var showSolvedAlert = false
    @State private var showAutoCompleting = false

    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Spacer()
                Button {
                    PlayerAction.showSettings.send()
                } label: {
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large)
                }
            }
            VStack {
                ZStack {
                    BoardView()
                    CellsView()
                    autoComplete
                }
                InfoView()
            }
            MarkerPickerView()
            NumberPickerView()
        }
        .padding(.horizontal)
        .padding(.bottom)
        .alert("Play Again", isPresented: $showSolvedAlert) {
            Button("OK", role: .cancel) { controller.startGame() }
        }
        .onReceive(controller.eventPublisher) { eventType in
            switch eventType {
                case .solved:
                    showSolvedAlert = true
            }
        }
        .onReceive(controller.animationPublisher) { animationType in
            switch animationType {
                case let .showAutoCompleting(isShowing):
                    showAutoCompleting = isShowing
                default:
                    break
            }
        }
        .sheet(isPresented: $controller.showSettings) {
            PlayerAction.settingsDismiss.send()
        } content: {
            SettingsView()
        }
        .accentColor(controller.settings.useColor ? .gray : .accentColor)
    }

    var autoComplete: some View {
        Text(showAutoCompleting ? "Filling last number" : "")
            .font(.system(size: 27, weight: .heavy, design: .default))
            .foregroundColor(controller.settings.useColor ? .white : .accentColor)
            .zIndex(Double.greatestFiniteMagnitude)

    }
}

struct SudokuView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        controller.settings.useColor = false
        return SudokuPlayView()
            .environmentObject(controller)
            .environmentObject(controller.settings)
            .onAppear {
                controller.startGame()
            }
            .preferredColorScheme(.dark)
    }
}
