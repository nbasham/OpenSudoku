import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            SudokuPlayView()
                .navigationTitle("Easy")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        undoButton
                        almostSolveButton
                    }
                }
        }
        .navigationViewStyle(.stack)
    }

    private var undoButton: some View {
        Button {
            PlayerAction.undo.send()
        } label: {
            Image(systemName: "arrow.uturn.backward.circle")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        return ContentView()
            .environmentObject(controller)
            .onAppear {
                controller.startGame()
            }
    }
}
