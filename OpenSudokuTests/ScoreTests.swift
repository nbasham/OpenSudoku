import XCTest
@testable import OpenSudoku

class ScoreTests: XCTestCase {
    private var userDefaults: UserDefaults!

    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
    }

    let lowScore = ScoreModel(date: Date(), seconds: 260, numIncorrect: 3, numRemaining: 4)
    let highScore = ScoreModel(date: Date() + 1, seconds: 240, numIncorrect: 3, numRemaining: 4)

    func testScores() throws {
        for level in PuzzleDifficultyLevel.allCases {
            let scores = Scores.load(level: level, storage: userDefaults)
            XCTAssertTrue(scores.isEmpty)
        }
        for level in PuzzleDifficultyLevel.allCases {
            print(level.description)
            Scores.add(highScore, level: level, storage: userDefaults)
            let scores = Scores.load(level: level, storage: userDefaults)
            XCTAssertEqual(1, scores.count)
            XCTAssertEqual(highScore.score, scores.top(count: 1).first?.score)
            XCTAssertEqual(highScore.score, scores.recent(count: 1).first?.score)
            XCTAssertEqual(highScore.score, scores.last?.score)
            XCTAssertEqual(Double(highScore.score), scores.average)
        }
    }

    func testScoresAverage() throws {
        let scores = [
            highScore, lowScore
        ]
        XCTAssertEqual(scores.average, 360)
    }

    func testScoresRecent() throws {
        let scores = [
            highScore, lowScore
        ]
        let recentScores = scores.recent(count: 2)
        XCTAssertEqual(2, recentScores.count)
        XCTAssertEqual(highScore, recentScores[0])
        XCTAssertEqual(lowScore, recentScores[1])
        let scores2 = [
            lowScore, highScore
        ]
        let recentScores2 = scores2.recent(count: 2)
        XCTAssertEqual(highScore, recentScores2[0])
        XCTAssertEqual(lowScore, recentScores2[1])
    }

    func testScoresTop() throws {
        let scores = [
            highScore, lowScore
        ]
        let topScores = scores.top(count: 2)
        XCTAssertEqual(2, topScores.count)
        XCTAssertEqual(highScore.score, topScores[0].score)
        XCTAssertEqual(lowScore.score, topScores[1].score)
        XCTAssertEqual(highScore.score, topScores.mostRecent!.score)
        let scores2 = [
            lowScore, highScore
        ]
        let topScores2 = scores2.top(count: 2)
        XCTAssertEqual(2, topScores2.count)
        XCTAssertEqual(highScore.score, topScores2[0].score)
        XCTAssertEqual(lowScore.score, topScores2[1].score)
        XCTAssertEqual(highScore.score, topScores2.mostRecent!.score)
    }
}
