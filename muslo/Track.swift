import Foundation
import AVFoundation
import UIKit

struct Track: Identifiable {
    let id = UUID()
    let url: URL
    let title: String
    let artist: String
    let artwork: UIImage?

    init(url: URL) {
        self.url = url

        let asset = AVAsset(url: url)

        var foundTitle: String = url.lastPathComponent
        var foundArtist: String = ""
        var foundArtwork: UIImage? = nil

        for metadata in asset.commonMetadata {
            switch metadata.commonKey {
            case .commonKeyTitle?:
                if let value = metadata.stringValue {
                    foundTitle = value
                }
            case .commonKeyArtist?:
                if let value = metadata.stringValue {
                    foundArtist = value
                }
            case .commonKeyArtwork?:
                if let data = metadata.dataValue, let image = UIImage(data: data) {
                    foundArtwork = image
                }
            default:
                break
            }
        }

        self.title = foundTitle
        self.artist = foundArtist
        self.artwork = foundArtwork
    }
}
