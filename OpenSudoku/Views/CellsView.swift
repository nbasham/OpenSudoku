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
        let colorScheme: ColorScheme = .light
        let useColor = false
        let ui = UI()
        ui.calc(useColor: useColor, isDarkMode: colorScheme == .dark)
        let controller = SudokuController()
        controller.settings.useColor = useColor
        return CellsView()
            .environmentObject(ui)
            .environmentObject(controller)
            .environmentObject(controller.settings)
            .onAppear {
                controller.startGame()
            }
            .preferredColorScheme(colorScheme)
            .frame(width: 320, height: 320)
    }
}
