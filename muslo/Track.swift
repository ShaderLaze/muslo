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

    init(url: URL) {
        self.url = url

        let asset = AVAsset(url: url)

        var title = url.deletingPathExtension().lastPathComponent
        var artist: String?
        var album: String?
        var artwork: UIImage?

        for item in asset.commonMetadata {
            guard let key = item.commonKey?.rawValue else { continue }
            switch key {
            case "title":
                title = item.stringValue ?? title
            case "artist":
                artist = item.stringValue
            case "albumName":
                album = item.stringValue
            case "artwork":
                if let data = item.dataValue {
                    artwork = UIImage(data: data)
                }
            default:
                break
            }
        }

        self.title = title
        self.artist = artist
        self.album = album
        self.artwork = artwork
    }
}
