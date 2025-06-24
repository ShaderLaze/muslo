import Foundation

struct Track: Identifiable {
    let id = UUID()
    let url: URL

    var name: String {
        url.lastPathComponent
    }
}
