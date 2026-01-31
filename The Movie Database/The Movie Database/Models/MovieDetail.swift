//
//  MovieDetail.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

struct MovieDetail: Codable, Identifiable {
    let id: Int
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]?
    let homepage: String?
    let imdbId: String?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, adult, budget, genres, homepage, overview, popularity, revenue, runtime, status, tagline, title, video
        case backdropPath = "backdrop_path"
        case imdbId = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    // MARK: - Computed Properties

    var formattedRuntime: String? {
        guard let runtime = runtime, runtime > 0 else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    var releaseYear: String? {
        guard let releaseDate = releaseDate, releaseDate.count >= 4 else { return nil }
        return String(releaseDate.prefix(4))
    }

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: APIConstants.posterBaseURL + posterPath)
    }

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: APIConstants.backdropBaseURL + backdropPath)
    }
}
