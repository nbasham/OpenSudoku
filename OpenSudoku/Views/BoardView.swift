import SwiftUI

struct BoardView: View {
    let borderWidth: CGFloat = 2
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)

    var body: some View {
        ZStack {
            LazyVGrid(columns: cols, spacing: borderWidth) {

                ForEach((0...8), id: \.self) { gridIndex in
                    Rectangle()
                        .fill(gridIndex%2==0 ? Color(.systemGray6) : Color(.systemGray5))
                }
                .aspectRatio(1, contentMode: .fill)
            }
        }
        .padding(0)
        .background(
            Color.black
                .padding(-borderWidth)
        )
        .disabled(true)
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView().environment(\.colorScheme, .light)
            .frame(width: 362, height: 362)
    }
}
