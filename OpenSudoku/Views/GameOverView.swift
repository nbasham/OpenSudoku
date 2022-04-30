import SwiftUI

struct GameOverView: View {
    @EnvironmentObject var controller: SudokuController

    var body: some View {
        VStack(spacing: 24) {
            Text("Game Over")
                .font(.title)
            HStack {
                Text(controller.settings.difficultyLevel.description)
                Text(controller.time)
            }
            HStack {
                Spacer()
                Button("Play Again", role: .cancel) {
                    controller.startGame()
                }
                Spacer()
                Button("Scores", role: .cancel) {
                    controller.showScores = true
                }
                Spacer()
            }
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
            .preview()
    }
}
