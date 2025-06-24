// AudioPlayer.swift
import Foundation
import AVFoundation

final class AudioPlayer: ObservableObject {
    private var player: AVAudioPlayer?

    func play(url: URL) {
        // Открываем доступ к security-scoped URL
        let needsStop = url.startAccessingSecurityScopedResource()
        defer {
            if needsStop {
                url.stopAccessingSecurityScopedResource()
            }
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("AudioPlayer error:", error.localizedDescription)
        }
    }
}
