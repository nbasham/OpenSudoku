import SwiftUI

struct CellViewModel: Identifiable {
    let id: Int
    let fontWeight: Font.Weight
    let color: Color
    let value: String
    let fontSize: CGFloat = 17
    let backgroundColor: Color
}

extension CellViewModel {
    init(id: Int, model: CellModel, selectedIndex: Int, highlightedNumber: Int?) {
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
    }

    private static func bgColor(_ index: Int, value: Int?, selectedIndex: Int, highlightedNumber: Int?) -> Color {
        var color = Color.clear

//        if SudokuConstants.indexToGrid(index) % 2 != 0 {
//            color = .gray
//        }
        if value != nil && value == highlightedNumber {
            color = .green
        }
        if index == selectedIndex {
            color = .yellow
        }
        return color
    }
}
