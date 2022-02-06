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
                        .fill(gridIndex%2==0 ?
                              ui.evenGridColor :
                                ui.oddGridColor)
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
        let colorScheme: ColorScheme = .light
        let useColor = false
        let ui = UI()
        ui.calc(useColor: useColor, isDarkMode: colorScheme == .dark)
        let controller = SudokuController()
        controller.settings.useColor = useColor
        return BoardView()
            .environmentObject(ui)
            .environmentObject(controller)
            .environmentObject(controller.settings)
            .onAppear {
                controller.startGame()
            }
            .preferredColorScheme(colorScheme)
            .frame(width: 362, height: 362)
    }
}
