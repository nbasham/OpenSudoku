import SwiftUI

struct SudokuPlayView: View {
    @EnvironmentObject var controller: SudokuController
    @Environment(\.pixelLength) var pixelLength: CGFloat
    private let boardColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 9)
    private let pickerColumns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    @State private var showSolvedAlert = false

    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                BoardView()
                CellsView()
            }

            NumberPickerView()
        }
        .padding(.horizontal)
        .alert("Play Again", isPresented: $showSolvedAlert) {
            Button("OK", role: .cancel) { controller.startGame() }
        }
        .onReceive(controller.eventPublisher) { eventType in
            switch eventType {
                case .solved:
                    showSolvedAlert = true
            }
        }
    }
}

struct SudokuView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        return SudokuPlayView()
            .environmentObject(controller)
            .onAppear {
                controller.startGame()
            }
    }
}