import SwiftUI

struct ContentView: View {

    var body: some View {
        SudokuPlayView()
//        NavigationView {
//            SudokuPlayView()
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        almostSolveButton
//                    }
//                }
//        }
//        .navigationViewStyle(.stack)
//        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preview()
    }
}
