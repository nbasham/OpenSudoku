import SwiftUI

struct ScoresView: View {
    @EnvironmentObject var viewModel: ScoresViewModel

    var body: some View {
        VStack(spacing: 0) {
            List {
                Section(header: Text("Stats")) {
                    HStack {
                        Text("Level")
                        Spacer()
                        Text(viewModel.level)
                    }
                    HStack {
                        Text("Games played")
                        Spacer()
                        Text(viewModel.numGames)
                    }
                    HStack {
                        Text("Average")
                        Spacer()
                        Text(viewModel.average)
                    }
                }
                Section(header: Text("Recent Scores")) {
                    ForEach(viewModel.recentScores, id: \.self) { item in
                        row(item)
                    }
                }
                Section(header: Text("Top Scores")) {
                    ForEach(viewModel.topScores, id: \.self) { item in
                        row(item)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .environment(\.defaultMinListRowHeight, 34)
        }
        .onAppear {
        }
    }

    private func row(_ score: ScoreViewModel) -> some View {
        HStack {
            Text(score.score)
            Spacer()
            Text(score.date)
        }
    }
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        let scores = ScoresViewModel(scoreModels: ScoreModel.examples, level: .easy)
        ScoresView()
            .environmentObject(scores)
    }
}
