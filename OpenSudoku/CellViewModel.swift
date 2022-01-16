import SwiftUI

//let cellColors: Array<UIColor> = [UIColor.init(hex: "D62469"), UIColor.init(hex: "F87F1F"), UIColor.init(hex: "F9C71E"), UIColor.init(hex: "AFCE3B"), UIColor.init(hex: "187349"), UIColor.init(hex: "00ABED"), UIColor.init(hex: "0665AE"), UIColor.init(hex: "64095E"), UIColor.init(hex: "000000")];

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

    init(id: Int, number: Int?, conflicts: Bool = false, showIncorrect: Bool = true) {
        self.id = id
        self.color = conflicts && showIncorrect ? .red : .primary
        if let number = number {
            self.value = "\(number)"
        } else {
            self.value = ""
        }
    }
}

extension CellViewModel {
    init(id: Int, model: CellModel, cellMarkers: [Bool], isConflict: (Int, Int) -> Bool, selectedIndex: Int, highlightedNumber: Int?, showIncorrect: Bool) {
        self.id = id
        var conflict = false
        if let modelValue = model.value {
            value = "\(modelValue)"
            conflict = isConflict(id, modelValue)
        } else {
            value = ""
        }
        if !model.isCorrect || conflict {
            color = showIncorrect ? .red : .primary
        } else {
            color = .primary
        }
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

        if value != nil && value == highlightedNumber {
            color = .accentColor.opacity(0.7)
        }
        if index == selectedIndex {
            color = .accentColor.opacity(0.3)
        }
        return color
    }
}
