import SwiftUI

struct SudokuPlayView: View {
    @EnvironmentObject var controller: SudokuController
    @Environment(\.pixelLength) var pixelLength: CGFloat
    private let boardColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 9)
    private let pickerColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    @State private var showSolvedAlert = false

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
                }
                InfoView()
            }
            NumberPickerView()
            MarkerPickerView()
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
        .sheet(isPresented: $controller.showSettings) {
            PlayerAction.settingsDismiss.send()
        } content: {
            SettingsView()
        }
        .accentColor(controller.settings.useColor ? .gray : .accentColor)
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
            .preferredColorScheme(.light)
    }
}
