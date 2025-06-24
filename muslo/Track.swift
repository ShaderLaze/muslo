import Foundation
import AVFoundation
import UIKit

struct Track: Identifiable {
    let id = UUID()
    let url: URL
    let title: String
    let artist: String?
    let album: String?
    let artwork: UIImage?

    var name: String { title }

    init(url: URL) async {
        self.url = url

        let asset = AVURLAsset(url: url)

        var title = url.deletingPathExtension().lastPathComponent
        var artist: String?
        var album: String?
        var artwork: UIImage?

        if let metadata = try? await asset.load(.commonMetadata) {
            for item in metadata {
                guard let key = item.commonKey?.rawValue else { continue }
                switch key {
                case "title":
                    title = (try? await item.load(.stringValue)) ?? title
                case "artist":
                    artist = try? await item.load(.stringValue)
                case "albumName":
                    album = try? await item.load(.stringValue)
                case "artwork":
                    if let data = try? await item.load(.dataValue) {
                        artwork = UIImage(data: data)
                    }
                default:
                    break
                }
            }
        }

        self.title = title
        self.artist = artist
        self.album = album
        self.artwork = artwork
    }
}
