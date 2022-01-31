import Foundation

struct UndoState: Codable {
    let selectedIndex: Int
    let highlightedNumber: Int?
    let guesses: [Int?]
    var markers: [[Bool]]
}

struct LastPick {
    let isNumber: Bool
    let number: Int
    let marker: Int

    init(number: Int) {
        isNumber = true
        self.number = number
        marker = -1
    }

    init(marker: Int) {
        isNumber = false
        self.number = -1
        self.marker = marker
    }
}
