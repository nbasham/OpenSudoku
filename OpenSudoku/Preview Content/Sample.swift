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
