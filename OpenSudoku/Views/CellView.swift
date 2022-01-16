import SwiftUI

struct CellView: View {
    let model: CellViewModel
    @Environment(\.pixelLength) var pixelLength: CGFloat

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle()) // makes it touchable
            Text(model.value)
                .font(.system(size: model.fontSize, weight: model.fontWeight))
                .foregroundColor(model.color)
        }
        .aspectRatio(1, contentMode: .fit)
        .onTapGesture {
            PlayerAction.cellTap.send(obj: model.id)
        }
        .background( model.backgroundColor )
        .overlay(
            Rectangle()
                .foregroundColor(.clear)
                .border(.black, width: pixelLength)
        )
        .overlay(
            markerView()
        )
    }

    private func markerView() -> some View {
        let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
        return LazyVGrid(columns: cols, spacing: 0) {
            ForEach(model.markers, id: \.id) { marker in
                ZStack {
                    Text("\(marker.value)")
                        .font(.system(size: marker.fontSize))
                        .foregroundColor(marker.color)
                  }
                    .aspectRatio(1, contentMode: .fit)
                 }
       }
   }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(model: CellViewModel(id: 0, fontWeight: .regular, color: .primary, value: "9", backgroundColor: .clear, markers: MarkerViewModel.sample))
            .frame(width: 44, height: 44)
    }
}
