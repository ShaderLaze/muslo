import Foundation
import AVFoundation

final class AudioPlayer: ObservableObject {
    private var player: AVAudioPlayer?

    func play(url: URL) {
        let needsStop = url.startAccessingSecurityScopedResource()
        defer {
            if needsStop {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }

    func stop() {
        player?.stop()
    }
}
