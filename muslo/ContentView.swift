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
                    HStack(alignment: .center, spacing: 8) {
                        if let artwork = track.artwork {
                            Image(uiImage: artwork)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .cornerRadius(4)
                        } else {
                            Image(systemName: "music.note")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.secondary)
                        }

                        VStack(alignment: .leading) {
                            Text(track.title)
                                .font(.headline)
                            if let artist = track.artist {
                                Text(artist)
                                    .font(.subheadline)
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
