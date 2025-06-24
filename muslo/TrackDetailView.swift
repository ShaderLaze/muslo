import SwiftUI

struct TrackDetailView: View {
    let tracks: [Track]
    @Binding var currentIndex: Int
    @EnvironmentObject private var audioPlayer: AudioPlayer
    @Environment(\.dismiss) private var dismiss

    private var track: Track { tracks[currentIndex] }

    var body: some View {
        VStack {
            Spacer()
            if let image = track.artwork {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
            }
            Spacer()
            VStack(alignment: .leading) {
                Text(track.title)
                    .font(.title2)
                    .bold()
                if let artist = track.artist {
                    Text(artist)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)

            Slider(value: Binding(
                get: { audioPlayer.currentTime },
                set: { newValue in
                    audioPlayer.seek(to: newValue)
                }
            ), in: 0...max(audioPlayer.duration, 1))
            .padding()

            HStack(spacing: 40) {
                Button {
                    if currentIndex > 0 {
                        currentIndex -= 1
                    }
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.largeTitle)
                }
                Button {
                    audioPlayer.togglePlayPause()
                } label: {
                    Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 64))
                }
                Button {
                    if currentIndex < tracks.count - 1 {
                        currentIndex += 1
                    }
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.largeTitle)
                }
            }
            .padding(.bottom)
        }
        .onAppear {
            audioPlayer.play(url: track.url)
        }
        .onChange(of: currentIndex) { newValue in
            audioPlayer.play(url: tracks[newValue].url)
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") { dismiss() }
            }
        }
    }
}

