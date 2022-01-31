import SwiftUI

struct CellView: View {
    let model: CellViewModel
    @Environment(\.pixelLength) var pixelLength: CGFloat
    @EnvironmentObject var controller: SudokuController
    @EnvironmentObject var settings: Settings
    @State private var animationAmount = 1.0

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle()) // makes it touchable
            symbol()
                .onReceive(controller.animationPublisher) { animationType in
                    switch animationType {
                        case let .completed(index, animating, maxAnimation):
                            if model.id == index {
                                animationAmount = animating ? maxAnimation : 1
                            }
                    }
                }
        }
        .aspectRatio(1, contentMode: .fit)
        .background( model.backgroundColor )
        .overlay(
            Rectangle()
                .foregroundColor(.clear)
                .border(.black, width: pixelLength)
        )
        .overlay(
            markerView()
        )
        .gesture(TapGesture(count: 2).onEnded {
            PlayerAction.cellDoubleTap.send(obj: model.id)
        })
        .simultaneousGesture(TapGesture().onEnded {
            PlayerAction.cellTap.send(obj: model.id)
        })
    }

    private func colorSymbol() -> some View {
        ZStack {
            Circle()
                .foregroundColor(model.colorValue)
                .padding(6)
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
        .scaleEffect(animationAmount)
        .animation(
            .easeOut(duration: 0.5)
            .repeatCount(1, autoreverses: false), value: animationAmount
        )
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
                    .font(.system(size: marker.fontSize, weight: .heavy, design: .monospaced))
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
