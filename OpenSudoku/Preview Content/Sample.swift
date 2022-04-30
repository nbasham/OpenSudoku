//
//  Sample.swift
//  OpenSudoku
//
//  Created by Norman Basham on 1/15/22.
//

import Foundation

extension CellViewModel {
    static let sample = CellViewModel(id: 0, fontWeight: .regular, color: .primary, value: "5", colorValue: .black, colorOverlay: "X", backgroundColor: .clear, markers: MarkerViewModel.sample)
}

extension MarkerViewModel {
    static let sample: [MarkerViewModel] = [
        MarkerViewModel(id: 1, number: nil),
        MarkerViewModel(id: 2, number: nil),
        MarkerViewModel(id: 3, number: 3, conflicts: true),
        MarkerViewModel(id: 4, number: 4),
        MarkerViewModel(id: 5, number: nil),
        MarkerViewModel(id: 6, number: nil),
        MarkerViewModel(id: 7, number: nil),
        MarkerViewModel(id: 8, number: nil),
        MarkerViewModel(id: 9, number: 9)
    ]
}

extension ScoreModel {
    static let examples: [ScoreModel] = [
        ScoreModel(date: Date() - TimeInterval(60*60*24 * Int.random(in: 1...10)), seconds: 248, numIncorrect: 0, numRemaining: 1, usedColor: true),
        ScoreModel(date: Date() - TimeInterval(60*60*24 * Int.random(in: 1...10)), seconds: 222, numIncorrect: 0, numRemaining: 4, usedColor: false),
        ScoreModel(date: Date() - TimeInterval(60*60*24 * Int.random(in: 1...10)), seconds: 175, numIncorrect: 0, numRemaining: 8, usedColor: true),
        ScoreModel(date: Date() - TimeInterval(60*60*24 * Int.random(in: 1...10)), seconds: 243, numIncorrect: 1, numRemaining: 7, usedColor: false),
        ScoreModel(date: Date() - TimeInterval(60*60*24 * Int.random(in: 1...10)), seconds: 240, numIncorrect: 3, numRemaining: 4, usedColor: true),
        ScoreModel(date: Date() - TimeInterval(60*60*24 * Int.random(in: 1...10)), seconds: 210, numIncorrect: 0, numRemaining: 4, usedColor: false),
        ScoreModel(date: Date() - TimeInterval(60*60*24 * Int.random(in: 1...10)), seconds: 180, numIncorrect: 0, numRemaining: 8, usedColor: true),
        ScoreModel(date: Date() - TimeInterval(60*60*24 * Int.random(in: 1...10)), seconds: 233, numIncorrect: 1, numRemaining: 2, usedColor: false),
        ScoreModel(date: Date() - TimeInterval(60*60*24 * Int.random(in: 1...10)), seconds: 200, numIncorrect: 1, numRemaining: 8, usedColor: true)
    ]
}
