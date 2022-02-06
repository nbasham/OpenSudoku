import SwiftUI

struct NumberPickerView: View {
    @EnvironmentObject var ui: UI
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme

    private let cols = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

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
                    ui.numberPickerBackgroundColor
                )
                .clipShape(RoundedRectangle(cornerRadius: 9))
            }
        }
    }

    private func symbol(_ number: Int) -> some View {
        Group {
            if settings.useColor {
                Group {
                    UI.numberPickerColorImage
                        .font(UI.numberPickerColorImageFont)
                        .foregroundColor(Color.sudoku(value: number))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 8)
            } else {
                Text("\(number)")
                    .font(UI.numberPickerNumberFont)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
            }
        }
    }
}

struct NumberPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let colorScheme: ColorScheme = .light
        let useColor = false
        let ui = UI()
        ui.calc(useColor: useColor, isDarkMode: colorScheme == .dark)
        let controller = SudokuController()
        controller.settings.useColor = useColor
        return NumberPickerView()
            .environmentObject(ui)
            .environmentObject(controller)
            .environmentObject(controller.settings)
            .onAppear {
                controller.startGame()
            }
            .preferredColorScheme(colorScheme)
            .frame(width: 380, height: 320)
    }
}
