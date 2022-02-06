import SwiftUI

struct PreivewModifier: ViewModifier {
    func body(content: Content) -> some View {
        let colorScheme: ColorScheme = .light
        let useColor = false
        let ui = UI()
        ui.calc(useColor: useColor, isDarkMode: colorScheme == .dark)
        let controller = SudokuController()
        controller.settings.useColor = useColor
        return content
            .environmentObject(ui)
            .environmentObject(controller)
            .environmentObject(controller.settings)
            .onAppear {
                controller.startGame()
            }
            .preferredColorScheme(colorScheme)
    }
}

extension View {
    func preview() -> some View {
        modifier(PreivewModifier())
    }
}
