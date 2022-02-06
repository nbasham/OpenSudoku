import SwiftUI

struct UsageView: View {
    let number: Int
    @EnvironmentObject var ui: UI
    @EnvironmentObject var controller: SudokuController
    @Environment(\.pixelLength) var pixelLength: CGFloat
    @Environment(\.colorScheme) var colorScheme
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

    var body: some View {
        LazyVGrid(columns: cols, spacing: 0) {
            ForEach((0..<9), id: \.self) { cellIndex in
                ZStack {
                    if controller.model.usage[number-1][cellIndex] {
                        ui.usageOnColor
                    } else {
                        ui.usageOffColor
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Rectangle()
                        .foregroundColor(.clear)
                        .border(ui.usageLineColor, width: pixelLength)
                )
            }
        }
    }
}

struct UsageView_Previews: PreviewProvider {
    static var previews: some View {
        let colorScheme: ColorScheme = .dark
        let useColor = false
        let ui = UI()
        ui.calc(useColor: useColor, isDarkMode: colorScheme == .dark)
        let controller = SudokuController()
        controller.settings.useColor = useColor
        return UsageView(number: 1)
            .environmentObject(ui)
            .environmentObject(controller)
            .environmentObject(controller.settings)
            .onAppear {
                controller.startGame()
            }
            .preferredColorScheme(colorScheme)
            .frame(width: 48, height: 48)
    }
}

