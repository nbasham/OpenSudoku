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

    init(id: Int, color: Color = .primary, value: String = "") {
        self.id = id
        self.color = color
        self.value = value
    }
    static let sample: [MarkerViewModel] = [
        MarkerViewModel(id: 1, color: .primary, value: ""),
        MarkerViewModel(id: 2, color: .primary, value: ""),
        MarkerViewModel(id: 3, color: .red, value: "3"),
        MarkerViewModel(id: 4, color: .primary, value: "4"),
        MarkerViewModel(id: 5, color: .primary, value: ""),
        MarkerViewModel(id: 6, color: .primary, value: ""),
        MarkerViewModel(id: 7, color: .primary, value: ""),
        MarkerViewModel(id: 8, color: .primary, value: ""),
        MarkerViewModel(id: 9, color: .primary, value: "")
    ]
}


extension CellViewModel {
    init(id: Int, model: CellModel, selectedIndex: Int, highlightedNumber: Int?, cellMarkers: [Bool]) {
        self.id = id
        if let modelValue = model.value {
            value = "\(modelValue)"
        } else {
            value = ""
        }
        if !model.isCorrect || model.conflicts {
            color = .red
        } else {
            color = .primary
        }
        fontWeight = model.isClue ? .bold : .regular
        backgroundColor = CellViewModel.bgColor(id, value: model.value, selectedIndex: selectedIndex, highlightedNumber: highlightedNumber)

        let isConflict: (Int, Int) -> Bool  = { _, _ in
            return false
        }
        let markerColor: (Int, Int) -> (Color)  = {  index, number in
            guard cellMarkers[number-1] else { return .primary }
            let conflicts = isConflict(id, number)
            return conflicts ? .red : .primary
        }
        let markerValue: (Int, Int) -> (String)  = {  index, number in
            guard cellMarkers[number-1] else { return "" }
            return "\(number)"
        }
        markers = (1...9).map { MarkerViewModel(id: $0, color: markerColor(id, $0), value: markerValue(id, $0))}
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
