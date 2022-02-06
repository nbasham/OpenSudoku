import SwiftUI

struct BoardView: View {
    @EnvironmentObject var ui: UI
    @EnvironmentObject var controller: SudokuController
    @Environment(\.colorScheme) var colorScheme
    private let boardCols = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)

    var body: some View {
        ZStack {
            LazyVGrid(columns: boardCols, spacing: UI.boardBorderWidth) {
                ForEach((0...8), id: \.self) { gridIndex in
                    Rectangle()
                        .fill(gridIndex.isMultiple(of: 2) ? ui.evenGridColor : ui.oddGridColor)
                }
                .aspectRatio(1, contentMode: .fill)
            }
        }
        .padding(0)
        .background(
            Color.primary
                .padding(-UI.boardBorderWidth)
        )
        .disabled(true)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .preview()
            .padding()
            .frame(maxWidth: .infinity)
    }
}
