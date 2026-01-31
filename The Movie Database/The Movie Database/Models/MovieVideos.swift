//
//  MovieVideos.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

struct MovieVideos: Codable {
    let id: Int?
    let results: [Video]?
}

// MARK: - Video
struct Video: Codable, Identifiable, Hashable {
    let id: String
    let iso6391: String?
    let iso31661: String?
    let key: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: String?
    let official: Bool?
    let publishedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, key, name, site, size, type, official
        case iso6391 = "iso_639_1"
        case iso31661 = "iso_3166_1"
        case publishedAt = "published_at"
    }

    // MARK: - Computed Properties

    var isYouTubeTrailer: Bool {
        site?.lowercased() == "youtube" && type?.lowercased() == "trailer"
    }

    var youtubeURL: URL? {
        guard let key = key, site?.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }

    var youtubeEmbedURL: URL? {
        guard let key = key, site?.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/embed/\(key)?playsinline=1")
    }

    var youtubeThumbnailURL: URL? {
        guard let key = key, site?.lowercased() == "youtube" else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg")
    }
}
