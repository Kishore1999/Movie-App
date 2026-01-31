//
//  Constants.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

enum APIConstants {
    static let apiKey = "db66b99ec97080c97adc3bc74b70096b" // Replace with your TMDb API key
    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p"

    // Image sizes
    static let posterSize = "w500"
    static let backdropSize = "w780"
    static let profileSize = "w185"

    // Full image URLs
    static var posterBaseURL: String {
        "\(imageBaseURL)/\(posterSize)"
    }

    static var backdropBaseURL: String {
        "\(imageBaseURL)/\(backdropSize)"
    }

    static var profileBaseURL: String {
        "\(imageBaseURL)/\(profileSize)"
    }
}
