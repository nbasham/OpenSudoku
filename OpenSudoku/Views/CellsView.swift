import SwiftUI

struct CellsView: View {
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 9)
    @EnvironmentObject var controller: SudokuController
    @Environment(\.pixelLength) var pixelLength: CGFloat

    var body: some View {
        LazyVGrid(columns: cols, spacing: 0) {
            ForEach(controller.viewModel, id: \.id) { cell in
                CellView(model: cell)
            }
        }
    }
}

struct CellsView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        return CellsView()
            .environmentObject(controller)
            .onAppear {
                controller.startGame()
            }
            .frame(width: 320, height: 320)
    }
}
