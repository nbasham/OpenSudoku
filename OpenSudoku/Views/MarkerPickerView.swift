import SwiftUI

struct MarkerPickerView: View {
    var body: some View {
        HStack {
            Image(systemName: "highlighter")
                .imageScale(.large)
            ForEach(1...9, id: \.self) { number in
                Button {
                    PlayerAction.markerGuess.send(obj: number)
                } label: {
                    Text("\(number)")
                }
                .padding(8)
            }

        }
    }
}

struct MarkerPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MarkerPickerView()
    }
}
