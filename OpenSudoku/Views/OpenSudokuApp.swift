//
//  OpenSudokuApp.swift
//
//  Created by Norman Basham on 12/30/21.
//

import SwiftUI

@main
struct OpenSudokuApp: App {

    @StateObject var controller = SudokuController()
    @StateObject var ui = UI()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ui)
                .environmentObject(controller)
                .environmentObject(controller.settings)
                .onAppear {
                    ui.calc(useColor: controller.settings.useColor)
                    controller.startGame()
                }
        }
    }
}

fileprivate struct NoopModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    /// Ensure that all previews have a complete set of environmental variabls.
    func preview() -> some View {
//  By using the #if defines here we don't have to expose them in the remaining view's `preview` code.
#if DEBUG
        modifier(PreivewModifier())
#else
        modifier(NoopModifier())
#endif
    }
}
