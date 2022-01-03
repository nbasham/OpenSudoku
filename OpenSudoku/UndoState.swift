import Foundation

struct UndoState: Codable {
    let selectedIndex: Int
    let highlightedNumber: Int?
    let guesses: [Int?]
}
