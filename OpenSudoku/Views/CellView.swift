import SwiftUI

struct CellView: View {
    let model: CellViewModel
    @Environment(\.pixelLength) var pixelLength: CGFloat
    @EnvironmentObject var settings: Settings

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle()) // makes it touchable
            symbol()
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

    private func colorSymbol() -> some View {
        ZStack {
            Circle()
                .foregroundColor(model.colorValue)
                .padding(4)
            if !model.colorOverlay.isEmpty {
                Circle()
                    .inset(by: 11)
                    .foregroundColor(.white)
                Circle()
                    .inset(by: 12)
                    .foregroundColor(.red)
            }
        }
    }


    private func symbol() -> some View {
        Group {
            if settings.useColor {
                colorSymbol()
           } else {
                Text(model.value)
                    .font(.system(size: model.fontSize, weight: model.fontWeight))
                    .foregroundColor(model.color)
            }
        }
    }

    private func markerSymbol(_ marker: MarkerViewModel) -> some View {
        Group {
            if settings.useColor {
                Image(systemName: marker.colorImage)
                    .font(.system(size: marker.fontSize))
                    .foregroundColor(marker.colorValue)
                    .padding(1)
            } else {
                Text("\(marker.value)")
                    .font(.system(size: marker.fontSize))
                    .foregroundColor(marker.color)
            }
        }
    }

    private func markerView() -> some View {
        let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
        return LazyVGrid(columns: cols, spacing: 0) {
            ForEach(model.markers, id: \.id) { marker in
                ZStack {
                    markerSymbol(marker)
                  }
                    .aspectRatio(1, contentMode: .fit)
                 }
       }
   }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        controller.settings.useColor = true
        return CellView(model: CellViewModel.sample)
            .frame(width: 44, height: 44)
            .environmentObject(controller)
            .environmentObject(controller.settings)
            .onAppear {
                controller.startGame()
            }
    }
}
