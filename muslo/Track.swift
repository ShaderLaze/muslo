import Foundation
import AVFoundation
import UIKit

struct Track: Identifiable {
    let id = UUID()
    let url: URL
    let title: String
    let artist: String
    let artwork: UIImage?

    init(url: URL) async {
        self.url = url

        let asset = AVURLAsset(url: url)

        var foundTitle: String = url.lastPathComponent
        var foundArtist: String = ""
        var foundArtwork: UIImage? = nil

        if let metadata = try? await asset.load(.commonMetadata) {
            for item in metadata {
                guard let key = item.commonKey else { continue }
                switch key {
                case .title:
                    if let value = try? await item.load(.stringValue) {
                        foundTitle = value
                    }
                case .artist:
                    if let value = try? await item.load(.stringValue) {
                        foundArtist = value
                    }
                case .artwork:
                    if let data = try? await item.load(.dataValue), let image = UIImage(data: data) {
                        foundArtwork = image
                    }
                default:
                    break
                }
            }
        }

        self.title = foundTitle
        self.artist = foundArtist
        self.artwork = foundArtwork
    }
}
