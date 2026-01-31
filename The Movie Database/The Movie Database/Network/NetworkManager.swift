//
//  NetworkManager.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    // MARK: - Generic GET Request

    func get<T: Decodable>(type: T.Type, endpoint: APIEndpoint) async -> Result<T, APIError> {
        guard let url = endpoint.url else {
            return .failure(.invalidURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                return .failure(.httpError(statusCode: httpResponse.statusCode))
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.decodingError(error))
            }
        } catch {
            return .failure(.networkError(error))
        }
    }

    // MARK: - Specific API Methods

    func fetchPopularMovies(page: Int = 1) async -> Result<MovieListData, APIError> {
        await get(type: MovieListData.self, endpoint: .popular(page: page))
    }

    func searchMovies(query: String, page: Int = 1) async -> Result<MovieListData, APIError> {
        await get(type: MovieListData.self, endpoint: .search(query: query, page: page))
    }

    func fetchMovieDetail(id: Int) async -> Result<MovieDetail, APIError> {
        await get(type: MovieDetail.self, endpoint: .movieDetail(id: id))
    }

    func fetchMovieCredits(id: Int) async -> Result<MovieCredits, APIError> {
        await get(type: MovieCredits.self, endpoint: .movieCredits(id: id))
    }

    func fetchMovieVideos(id: Int) async -> Result<MovieVideos, APIError> {
        await get(type: MovieVideos.self, endpoint: .movieVideos(id: id))
    }
}
