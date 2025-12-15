import SwiftUI
import FirebaseAuth

struct HomeView: View {

    @State private var isCreating = false
    @State private var roomCode: String? = nil

    var body: some View {
        VStack(spacing: 32) {

            Text("Kart Tahmini")
                .font(.largeTitle)
                .fontWeight(.bold)

            // HOST FLOW
            if let code = roomCode {
                VStack(spacing: 12) {
                    Text("Oda Kodu")
                        .foregroundColor(.gray)

                    Text(code)
                        .font(.system(size: 36, weight: .bold))

                    NavigationLink {
                        GameView()
                    } label: {
                        Text("Oyuna Geç")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                    }
                }
            } else {
                // CREATE GAME
                Button {
                    createGame()
                } label: {
                    if isCreating {
                        ProgressView()
                    } else {
                        Text("Oyun Oluştur")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                    }
                }

                // JOIN GAME
                NavigationLink {
                    JoinGameView()
                } label: {
                    Text("Koda Katıl")
                        .foregroundColor(.blue)
                }
            }

            Spacer()
        }
        .padding()
    }

    private func createGame() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isCreating = true

        FirebaseService.shared.createGameRoom(hostId: userId) { code in
            isCreating = false
            roomCode = code
        }
    }
}
