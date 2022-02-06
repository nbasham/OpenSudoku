import SwiftUI

struct MarkerPickerView: View {
    @EnvironmentObject var settings: Settings

    var body: some View {
        HStack {
            ForEach(1...9, id: \.self) { number in
                Button {
                    PlayerAction.markerGuess.send(obj: number)
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color(.systemGray5))
                        symbol(number)
                    }
                    .aspectRatio(1, contentMode: .fit)
                }
            }

        }
    }

    private func symbol(_ number: Int) -> some View {
        Group {
            if settings.useColor {
                Image(systemName: "circle.fill")
                    .font(.system(size: 15))
                    .foregroundColor(Color.sudoku(value: number))
                    .padding(1)
            } else {
                Text("\(number)")
                    .font(.system(size: 17))
                    .padding(6)
            }
        }
    }
}

struct MarkerPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        controller.settings.useColor = false
        return MarkerPickerView()
            .environmentObject(controller)
            .environmentObject(controller.settings)
            .onAppear {
                controller.startGame()
            }
    }
}
