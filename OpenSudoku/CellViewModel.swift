import SwiftUI

struct CellViewModel: Identifiable {
    let id: Int
    let fontWeight: Font.Weight
    let color: Color
    let value: String
    let fontSize: CGFloat = 17
    let backgroundColor: Color
    let markers: [MarkerViewModel]
}

struct MarkerViewModel: Identifiable {
    let id: Int
    let color: Color
    let value: String
    let fontSize: CGFloat = 9

    init(id: Int, number: Int?, conflicts: Bool = false) {
        self.id = id
        self.color = conflicts ? .red : .primary
        if let number = number {
            self.value = "\(number)"
        } else {
            self.value = ""
        }
    }

    static let sample: [MarkerViewModel] = [
        MarkerViewModel(id: 1, number: nil),
        MarkerViewModel(id: 2, number: nil),
        MarkerViewModel(id: 3, number: 3, conflicts: true),
        MarkerViewModel(id: 4, number: 4),
        MarkerViewModel(id: 5, number: nil),
        MarkerViewModel(id: 6, number: nil),
        MarkerViewModel(id: 7, number: nil),
        MarkerViewModel(id: 8, number: nil),
        MarkerViewModel(id: 9, number: nil)
    ]
}


extension CellViewModel {
    init(id: Int, model: CellModel, selectedIndex: Int, highlightedNumber: Int?, cellMarkers: [Bool], isConflict: (Int, Int) -> Bool) {
        self.id = id
        var conflict = false
        if let modelValue = model.value {
            value = "\(modelValue)"
            conflict = isConflict(id, modelValue)
        } else {
            value = ""
        }
        if !model.isCorrect || conflict {
            color = .red
        } else {
            color = .primary
        }
        fontWeight = model.isClue ? .bold : .regular
        backgroundColor = CellViewModel.bgColor(id, value: model.value, selectedIndex: selectedIndex, highlightedNumber: highlightedNumber)

//        let isConflict: (Int, Int) -> Bool  = { _, _ in
//            return false
//        }
//        let markerColor: (Int, Int) -> (Color)  = {  index, number in
//            guard cellMarkers[number-1] else { return .primary }
//            let conflicts = isConflict(id, number)
//            return conflicts ? .red : .primary
//        }
        let markerValue: (Int, Int) -> (Int?)  = {  index, number in
            guard cellMarkers[number-1] else { return nil }
            return number
        }
        markers = (1...9).map { MarkerViewModel(id: $0, number: markerValue(id, $0), conflicts: isConflict(id, $0))}
    }

    private static func bgColor(_ index: Int, value: Int?, selectedIndex: Int, highlightedNumber: Int?) -> Color {
        var color = Color.clear

//        if SudokuConstants.indexToGrid(index) % 2 != 0 {
//            color = .gray
//        }
        if value != nil && value == highlightedNumber {
            color = .accentColor.opacity(0.7)
        }
        if index == selectedIndex {
            color = .accentColor.opacity(0.3)
        }
        return color
    }
}
