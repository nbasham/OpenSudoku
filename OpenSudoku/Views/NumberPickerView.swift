import SwiftUI

struct NumberPickerView: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme

    private let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

    var body: some View {
        LazyVGrid(columns: cols, spacing: 20) {
            ForEach(1...9, id: \.self) { number in
                HStack {
                    Button {
                        PlayerAction.numberGuess.send(obj: number)
                    } label: {
                        HStack {
                            symbol(number)
                            UsageView(number: number)
                                .padding(4)
                                .padding(.trailing)
                                .onTapGesture {
                                    PlayerAction.usageTap.send(obj: number)
                                }

                        }
                    }
                }
                .background(
                    Color(colorScheme == .dark ? .systemGray4 : .systemGray5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 9))
            }
        }
    }

    private func symbol(_ number: Int) -> some View {
        Group {
            if settings.useColor {
                Group {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 25))
                        .foregroundColor(Color.sudoku(value: number))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 8)
            } else {
                Text("\(number)")
                    .font(.system(size: 29))
                    .padding(8)
            }
        }
    }
}

struct NumberPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        controller.settings.useColor = true
        return NumberPickerView()
            .environmentObject(controller)
            .environmentObject(controller.settings)
            .onAppear {
                controller.startGame()
            }
    }
}
