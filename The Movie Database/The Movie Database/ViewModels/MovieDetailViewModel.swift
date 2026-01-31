//
//  MovieDetailViewModel.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

@MainActor
final class MovieDetailViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var movieDetail: MovieDetail?
    @Published private(set) var credits: MovieCredits?
    @Published private(set) var videos: MovieVideos?
    @Published private(set) var isLoading = false
    @Published private(set) var error: APIError?

    // MARK: - Computed Properties

    var trailer: Video? {
        videos?.results?.first { $0.isYouTubeTrailer }
    }

    var topCast: [CastMember] {
        guard let cast = credits?.cast else { return [] }
        return Array(cast.sorted { ($0.order ?? 999) < ($1.order ?? 999) }.prefix(10))
    }

    var director: CrewMember? {
        credits?.crew?.first { $0.job?.lowercased() == "director" }
    }

    // MARK: - Public Methods

    func fetchMovieDetails(movieId: Int) async {
        isLoading = true
        error = nil

        // Fetch all data in parallel
        async let detailResult = NetworkManager.shared.fetchMovieDetail(id: movieId)
        async let creditsResult = NetworkManager.shared.fetchMovieCredits(id: movieId)
        async let videosResult = NetworkManager.shared.fetchMovieVideos(id: movieId)

        let (detail, credits, videos) = await (detailResult, creditsResult, videosResult)

        // Handle detail result
        switch detail {
        case .success(let data):
            self.movieDetail = data
        case .failure(let apiError):
            self.error = apiError
        }

        // Handle credits result (non-critical, don't set error)
        if case .success(let data) = credits {
            self.credits = data
        }

        // Handle videos result (non-critical, don't set error)
        if case .success(let data) = videos {
            self.videos = data
        }

        isLoading = false
    }

    func clearError() {
        error = nil
    }
}
