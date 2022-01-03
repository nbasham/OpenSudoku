//
//  OpenSudokuApp.swift
//
//  Created by Norman Basham on 12/30/21.
//

import SwiftUI

@main
struct OpenSudokuApp: App {

    @StateObject var controller = SudokuController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(controller)
                .onAppear {
                    controller.startGame()
                }
        }
    }
}
