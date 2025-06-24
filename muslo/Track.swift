import Foundation
import AVFoundation

struct Track: Identifiable {
    let id = UUID()
    let url: URL

    var title: String?
    var artist: String?
    var artworkData: Data?

    init(url: URL) {
        self.url = url
    }

    mutating func loadMetadata() async {
        let asset = AVURLAsset(url: url)

        do {
            let items = try await asset.load(.commonMetadata)
            for item in items {
                guard let key = item.commonKey else { continue }
                switch key {
                case .commonKeyTitle:
                    title = try await item.load(.stringValue)
                case .commonKeyArtist:
                    artist = try await item.load(.stringValue)
                case .commonKeyArtwork:
                    artworkData = try await item.load(.dataValue)
                default:
                    break
                }
            }
        } catch {
            print("Failed to load metadata: \(error)")
        }
    }

    var name: String {
        title ?? url.lastPathComponent
    }
}
