import SwiftUI

struct GameView: View {

    // GAME STATE
    @State private var gameState = GameState()

    // PREDICTION STATE
    @State private var selectedSuit: Suit? = nil
    @State private var selectedRank: Rank = .ace
    @State private var predictionLocked = false
    @State private var currentPrediction: Prediction? = nil

    // UI STATE
    @State private var showCelebration = false

    var body: some View {
        VStack(spacing: 24) {

            // ROUND & SCORE
            VStack(spacing: 8) {
                Text("Round \(min(gameState.currentRound, gameState.totalRounds)) / \(gameState.totalRounds)")
                    .font(.headline)

                Text("Score: \(totalScore)")
                    .font(.title3)
            }

            // LAST REVEALED CARD
            if let last = gameState.history.last {
                VStack(spacing: 4) {
                    Text("Revealed Card")
                        .foregroundColor(.gray)

                    Text("\(last.revealedCard.rank.display) \(last.revealedCard.suit.rawValue)")
                        .font(.largeTitle)
                }
            }

            // PREDICTION UI
            predictionSection

            // ACTION
            Button("Reveal Card") {
                revealRound()
            }
            .disabled(!predictionLocked || isGameFinished)

            // HISTORY
            historySection

            Spacer()
        }
        .padding()
        .navigationTitle("Game")
        .overlay {
            if showCelebration {
                celebrationOverlay
            }
        }
        .overlay {
            if isGameFinished {
                gameFinishedOverlay
            }
        }
    }

    // MARK: - COMPUTED

    private var totalScore: Int {
        gameState.history.reduce(0) { $0 + $1.pointsEarned }
    }

    private var isGameFinished: Bool {
        gameState.history.count == gameState.totalRounds
    }

    // MARK: - PREDICTION UI

    private var predictionSection: some View {
        VStack(spacing: 16) {

            HStack(spacing: 20) {
                ForEach(Suit.allCases, id: \.self) { suit in
                    Button {
                        if !predictionLocked && !isGameFinished {
                            selectedSuit = suit
                        }
                    } label: {
                        Text(suit.rawValue)
                            .font(.largeTitle)
                            .padding()
                            .background(
                                Circle()
                                    .fill(selectedSuit == suit
                                          ? Color.orange.opacity(0.3)
                                          : Color.clear)
                            )
                    }
                }
            }

            Picker("Rank", selection: $selectedRank) {
                ForEach(Rank.allCases, id: \.self) { rank in
                    Text(rank.display).tag(rank)
                }
            }
            .pickerStyle(.segmented)
            .disabled(predictionLocked || isGameFinished)

            Button("Tahmini Gönder") {
                guard let suit = selectedSuit else { return }
                currentPrediction = Prediction(suit: suit, rank: selectedRank)
                predictionLocked = true
            }
            .disabled(selectedSuit == nil || predictionLocked || isGameFinished)
        }
    }

    // MARK: - GAME LOGIC

    private func revealRound() {
        guard let prediction = currentPrediction else { return }

        gameState.reveal(prediction: prediction) { pred, card in
            var pts = 0
            if pred.suit == card.suit { pts += 1 }
            if pred.rank == card.rank { pts += 2 }
            return pts
        }

        if let last = gameState.history.last {
            showCelebration = (last.pointsEarned == 3)
        }

        // RESET INPUT FOR NEXT ROUND
        selectedSuit = nil
        selectedRank = .ace
        predictionLocked = false
        currentPrediction = nil
    }

    private func restartGame() {
        gameState = GameState()
        selectedSuit = nil
        selectedRank = .ace
        predictionLocked = false
        currentPrediction = nil
        showCelebration = false
    }

    // MARK: - HISTORY

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(gameState.history) { round in
                HStack {
                    Text("#\(round.roundIndex)")
                    Spacer()
                    Text("\(round.prediction.rank.display)\(round.prediction.suit.rawValue)")
                    Text("→")
                    Text("\(round.revealedCard.rank.display)\(round.revealedCard.suit.rawValue)")
                    Spacer()
                    Text("+\(round.pointsEarned)")
                }
                .font(.caption)
            }
        }
    }

    // MARK: - OVERLAYS

    private var celebrationOverlay: some View {
        Text("🎉 PERFECT GUESS 🎉")
            .font(.title)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .onTapGesture {
                showCelebration = false
            }
    }

    private var gameFinishedOverlay: some View {
        VStack(spacing: 16) {
            Text("Game Finished")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Final Score: \(totalScore)")
                .font(.title2)

            Button("Yeni Oyun") {
                restartGame()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
        .padding()
        .frame(maxWidth: 300)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
    }
}

#Preview {
    GameView()
}
