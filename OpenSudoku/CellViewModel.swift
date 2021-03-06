import SwiftUI

struct CellViewModel: Identifiable {
    let id: Int
    let fontWeight: Font.Weight
    let color: Color
    let value: String
    let colorValue: Color
    let colorOverlay: String
    let fontSize: CGFloat = 17
    let backgroundColor: Color
    let markers: [MarkerViewModel]
}

struct MarkerViewModel: Identifiable {
    let id: Int
    let color: Color
    let value: String
    let colorValue: Color
    let colorImage: String
    let fontSize: CGFloat = 9

    init(id: Int, number: Int?, conflicts: Bool = false, showIncorrect: Bool = true) {
        self.id = id
        let conflictsOrIncorrect = conflicts && showIncorrect
        self.color = conflictsOrIncorrect ? .red : .primary
        if let number = number {
            self.value = "\(number)"
            colorValue = Color.sudoku(value: number)
        } else {
            self.value = ""
            colorValue = .clear
        }
        colorImage = conflicts ? "record.circle" : "circle.fill"
    }
}

extension CellViewModel {
    init(id: Int, model: CellModel, cellMarkers: [Bool], isConflict: (Int, Int) -> Bool, selectedIndex: Int, highlightedNumber: Int?, showIncorrect: Bool) {
        self.id = id
        var conflict = false
        if let modelValue = model.value {
            value = "\(modelValue)"
            conflict = isConflict(id, modelValue)
            colorValue = Color.sudoku(value: modelValue)
        } else {
            value = ""
            colorValue = .clear
        }
        var tempColorOverlay = ""
        if !model.isCorrect || conflict {
            color = showIncorrect ? .red : .primary
            if !model.isClue && model.value != nil {
                tempColorOverlay = showIncorrect ? "x" : ""
            }
        } else {
            color = .primary
        }
        colorOverlay = tempColorOverlay

        fontWeight = model.isClue ? .bold : .regular
        backgroundColor = CellViewModel.bgColor(id, value: model.value, selectedIndex: selectedIndex, highlightedNumber: highlightedNumber)

        let markerValue: (Int, Int) -> (Int?)  = {  index, number in
            guard cellMarkers[number-1] else { return nil }
            return number
        }
        markers = (1...9).map { MarkerViewModel(id: $0, number: markerValue(id, $0), conflicts: isConflict(id, $0), showIncorrect: showIncorrect)}
    }

    private static func bgColor(_ index: Int, value: Int?, selectedIndex: Int, highlightedNumber: Int?) -> Color {
        var color = Color.clear
        let baseColor: Color = UITraitCollection.current.userInterfaceStyle == .light ? .accentColor : .white

        if value != nil && value == highlightedNumber {
            color = baseColor.opacity(0.7)
        }
        if index == selectedIndex {
            color = baseColor.opacity(0.3)
        }
        return color
    }
}
