// AudioPlayer.swift
import Foundation
import AVFoundation

final class AudioPlayer: ObservableObject {
    private var player: AVAudioPlayer?
    private var timer: Timer?

    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0

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
            duration = player?.duration ?? 0
            player?.prepareToPlay()
            player?.play()
            isPlaying = true
            startTimer()
        } catch {
            print("AudioPlayer error:", error.localizedDescription)
        }
    }

    func togglePlayPause() {
        guard let player = player else { return }
        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func seek(to time: TimeInterval) {
        player?.currentTime = time
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            DispatchQueue.main.async {
                self.currentTime = player.currentTime
                self.isPlaying = player.isPlaying
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
