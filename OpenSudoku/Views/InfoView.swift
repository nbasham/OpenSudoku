import SwiftUI

struct InfoView: View {
    @EnvironmentObject var controller: SudokuController
    @EnvironmentObject var settings: Settings
    private let fontSize: CGFloat = 15

    var body: some View {
        HStack {
            if settings.showTimer {
                Text(controller.time)
                    .font(.system(size: fontSize, weight: .regular, design: .monospaced))
                Spacer()
            }
            Text(settings.difficultyLevel.description.uppercased())
                .font(.system(size: fontSize, weight: .regular, design: .default))
            Spacer()
            undoButton
        }
    }

    private var undoButton: some View {
        Button {
            PlayerAction.undo.send()
        } label: {
            //Image(systemName: "arrow.uturn.backward.circle")
            Text("Undo")
                .font(.system(size: fontSize, weight: .regular, design: .default))
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .preview()
            .padding()
    }
}
