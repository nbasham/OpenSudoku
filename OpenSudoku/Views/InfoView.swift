import SwiftUI

struct InfoView: View {
    @EnvironmentObject var settings: Settings
    private let fontSize: CGFloat = 15

    var body: some View {
        HStack {
            Text("00:00")
                .font(.system(size: fontSize, weight: .regular, design: .monospaced))
            Spacer()
            Text("\(settings.difficultyLevel)")
                .font(.system(size: fontSize, weight: .regular, design: .default))
            Spacer()
            undoButton
        }
    }

    private var undoButton: some View {
        Button {
            PlayerAction.undo.send()
        } label: {
            Text("Undo")
                .font(.system(size: fontSize, weight: .regular, design: .default))
//            Image(systemName: "arrow.uturn.backward.circle")
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
