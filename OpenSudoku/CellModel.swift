import Foundation

struct CellModel: Codable {
    let isClue: Bool
    let value: Int?
    let isCorrect: Bool
    var markers: [Bool]
}
