import SwiftUI
import UniformTypeIdentifiers
import AVFoundation
import UIKit

struct ContentView: View {
    @State private var tracks: [Track] = []
    @State private var isImporterPresented = false
    @StateObject private var player = AudioPlayer()

    var body: some View {
        NavigationStack {
            List {
                ForEach(tracks) { track in
                    HStack {
                        if let artwork = track.artwork {
                            Image(uiImage: artwork)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(4)
                        } else {
                            Image(systemName: "music.note")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.secondary)
                        }
                        VStack(alignment: .leading) {
                            Text(track.title)
                                .font(.headline)
                            Text(track.artist)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
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
                        let track = await Track(url: url)
                        await MainActor.run { tracks.append(track) }
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
