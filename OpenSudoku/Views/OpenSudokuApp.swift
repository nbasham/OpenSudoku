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
