import SwiftUI

struct MarkerPickerView: View {
    var body: some View {
        HStack {
//            Image(systemName: "highlighter")
//                .imageScale(.large)
            ForEach(1...9, id: \.self) { number in
                Button {
                    PlayerAction.markerGuess.send(obj: number)
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color(.systemGray5))
                        Text("\(number)")
//                            .foregroundColor(.primary)
                    }
                    .aspectRatio(1, contentMode: .fill)
                }
//                .padding(8)
            }

        }
        .frame(maxWidth: .infinity)
    }
}

struct MarkerPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MarkerPickerView()
    }
}
