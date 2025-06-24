// ContentView.swift
import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var tracks: [Track] = []
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var showingImporter = false

    var body: some View {
        NavigationView {
            List(tracks) { track in
                HStack {
                    if let image = track.artwork {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(4)
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 50, height: 50)
                            .cornerRadius(4)
                    }
                    VStack(alignment: .leading) {
                        Text(track.title)
                            .font(.headline)
                        if let artist = track.artist {
                            Text(artist)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onTapGesture {
                    audioPlayer.play(url: track.url)
                }
            }
            .navigationTitle("Моя музыка")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingImporter = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $showingImporter,
                allowedContentTypes: [.audio],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    if let url = urls.first {
                        Task {
                            let track = await Track(url: url)
                            await MainActor.run {
                                tracks.append(track)
                            }
                        }
                    }
                case .failure(let error):
                    print("Importer error:", error.localizedDescription)
                }
            }
        }
        .environmentObject(audioPlayer)
    }
}
