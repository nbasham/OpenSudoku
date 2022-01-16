import SwiftUI

struct NumberPickerView: View {
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)

    var body: some View {
        LazyVGrid(columns: cols, spacing: 20) {
            ForEach(1...9, id: \.self) { number in
                HStack {
                    Button {
                        PlayerAction.numberGuess.send(obj: number)
                    } label: {
                        HStack {
                            Text("\(number)")
                                .padding()
                            UsageView(number: number)
                                .padding(4)
                                .padding(.trailing)
                        }
                    }
                }
                .background(
                    Color(.systemGray5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 9))
            }
        }
    }
}

struct NumberPickerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = SudokuController()
        return NumberPickerView()
            .environmentObject(controller)
            .onAppear {
                controller.startGame()
            }
    }
}
