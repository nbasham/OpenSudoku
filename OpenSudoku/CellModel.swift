import Foundation

struct CellModel: Codable {
    let isClue: Bool
    let value: Int?
    let isCorrect: Bool
    let conflicts: Bool
    var markers: [Bool]
}
