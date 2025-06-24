// Track.swift
import Foundation
import UIKit
import AVFoundation

struct Track: Identifiable {
    let id = UUID()
    let url: URL
    let title: String
    let artist: String?
    let album: String?
    let artwork: UIImage?

    init(url: URL) async {
        // Доступ к защищённому URL
        let needsStop = url.startAccessingSecurityScopedResource()
        defer {
            if needsStop {
                url.stopAccessingSecurityScopedResource()
            }
        }

        self.url = url
        let asset = AVURLAsset(url: url)

        // Значения по умолчанию
        var title = url.deletingPathExtension().lastPathComponent
        var artist: String?
        var album: String?
        var artwork: UIImage?

        // Загружаем общие метаданные
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
