import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct ContentView: View {
    @State private var tracks: [Track] = []
    @State private var isImporterPresented = false
    @StateObject private var player = AudioPlayer()

    var body: some View {
        NavigationStack {
            List {
                ForEach(tracks) { track in
                    HStack {
                        Text(track.name)
                        Spacer()
                        Button(action: {
                            player.play(url: track.url)
                        }) {
                            Image(systemName: "play.circle")
                        }
                    }
                }
            }
            .navigationTitle("Tracks")
            .toolbar {
                Button(action: { isImporterPresented = true }) {
                    Image(systemName: "plus")
                }
            }
            .fileImporter(
                isPresented: $isImporterPresented,
                allowedContentTypes: [.audio]
            ) { result in
                switch result {
                case .success(let url):
                    tracks.append(Track(url: url))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
