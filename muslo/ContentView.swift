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
                        VStack(alignment: .leading) {
                            Text(track.name)
                            if let artist = track.artist {
                                Text(artist)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
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
                    Task {
                        var track = Track(url: url)
                        await track.loadMetadata()
                        tracks.append(track)
                    }
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
