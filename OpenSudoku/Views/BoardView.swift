import SwiftUI

struct BoardView: View {
    @EnvironmentObject var controller: SudokuController
    let borderWidth: CGFloat = 2
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)
    @Environment(\.colorScheme) var colorScheme
    @State private var showAutoCompleting = false

    var body: some View {
        ZStack {
            LazyVGrid(columns: cols, spacing: borderWidth) {

                ForEach((0...8), id: \.self) { gridIndex in
                    Rectangle()
                        .fill(gridIndex%2==0 ?
                              Color(colorScheme == .dark ? .systemGray : .systemGray6) :
                                Color(colorScheme == .dark ? .systemGray2 : .systemGray5))
                }
                .aspectRatio(1, contentMode: .fill)
            }
            autoComplete
        }
        .padding(0)
        .background(
            Color.primary
                .padding(-borderWidth)
        )
        .disabled(true)
        .onReceive(controller.animationPublisher) { animationType in
            switch animationType {
                case let .showAutoCompleting(isShowing):
                    showAutoCompleting = isShowing
                default:
                    break
            }
        }
    }

    var autoComplete: some View {
        Text(showAutoCompleting ? "Filling in last number!" : "")
            .font(.system(size: 27, weight: .heavy, design: .default))

    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        return BoardView()
            .environmentObject(controller)
            .environment(\.colorScheme, .light)
            .frame(width: 362, height: 362)
    }
}
