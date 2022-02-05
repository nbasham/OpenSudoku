import SwiftUI

struct UsageView: View {
    let number: Int
    @EnvironmentObject var controller: SudokuController
    @Environment(\.pixelLength) var pixelLength: CGFloat
    @Environment(\.colorScheme) var colorScheme
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

    var body: some View {
        LazyVGrid(columns: cols, spacing: 0) {
            ForEach((0..<9), id: \.self) { cellIndex in
                ZStack {
                    if controller.model.usage[number-1][cellIndex] {
                        colorScheme == .dark ? Color(.systemGray5) : Color.accentColor

                    } else {
                        Color(colorScheme == .dark ? .systemGray3 : .systemGray5)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Rectangle()
                        .foregroundColor(.clear)
                        .border(colorScheme == .dark ? Color.gray : Color.black, width: pixelLength)
                )
            }
        }
    }
}

struct UsageView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        UsageView(number: 1)
            .frame(width: 48, height: 48)
            .environmentObject(controller)
            .onAppear {
                controller.startGame()
            }
            .preferredColorScheme(.dark)
    }
}

