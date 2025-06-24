import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var audioPlayer: AudioPlayer
    @Binding var tracks: [Track]
    @Binding var index: Int
    @Environment(\.dismiss) private var dismiss

    private var track: Track { tracks[index] }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    if let artwork = track.artwork {
                        Image(uiImage: artwork)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.width)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: geo.size.width, height: geo.size.width)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(track.title)
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        if let artist = track.artist {
                            Text(artist)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    ProgressBar(
                        currentTime: Binding(
                            get: { audioPlayer.currentTime },
                            set: { audioPlayer.currentTime = $0 }
                        ),
                        duration: audioPlayer.duration,
                        seek: { audioPlayer.seek(to: $0) }
                    )
                    .padding(.horizontal)
                    HStack {
                        Text(formatTime(audioPlayer.currentTime))
                        Spacer()
                        Text(formatTime(audioPlayer.duration))
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.horizontal)
                    HStack(spacing: 40) {
                        Button(action: previous) {
                            Image(systemName: "backward.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        Button(action: { audioPlayer.togglePlayPause() }) {
                            Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        }
                        Button(action: next) {
                            Image(systemName: "forward.fill")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .onAppear {
            audioPlayer.play(url: track.url)
        }
        .onChange(of: index) { _ in
            audioPlayer.play(url: track.url)
        }
        .onTapGesture(count: 2) {
            dismiss()
        }
    }

    private func next() {
        guard index + 1 < tracks.count else { return }
        index += 1
    }

    private func previous() {
        guard index > 0 else { return }
        index -= 1
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    PlayerView(tracks: .constant([]), index: .constant(0))
        .environmentObject(AudioPlayer())
}
