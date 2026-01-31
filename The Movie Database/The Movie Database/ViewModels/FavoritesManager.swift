//
//  FavoritesManager.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

@MainActor
final class FavoritesManager: ObservableObject {

    // MARK: - Properties

    @Published private(set) var favoriteMovies: [Movie] = []

    private let userDefaultsKey = "favorite_movies"

    // MARK: - Init

    init() {
        loadFavorites()
    }

    // MARK: - Public Methods

    func isFavorite(_ movie: Movie) -> Bool {
        favoriteMovies.contains { $0.id == movie.id }
    }

    func isFavorite(movieId: Int) -> Bool {
        favoriteMovies.contains { $0.id == movieId }
    }

    func toggleFavorite(_ movie: Movie) {
        if isFavorite(movie) {
            removeFavorite(movie)
        } else {
            addFavorite(movie)
        }
    }

    func addFavorite(_ movie: Movie) {
        guard !isFavorite(movie) else { return }
        favoriteMovies.insert(movie, at: 0)
        saveFavorites()
    }

    func removeFavorite(_ movie: Movie) {
        favoriteMovies.removeAll { $0.id == movie.id }
        saveFavorites()
    }

    func removeFavorite(movieId: Int) {
        favoriteMovies.removeAll { $0.id == movieId }
        saveFavorites()
    }

    // MARK: - Private Methods

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }

        do {
            let decoder = JSONDecoder()
            favoriteMovies = try decoder.decode([Movie].self, from: data)
        } catch {
            print("Failed to load favorites: \(error)")
        }
    }

    private func saveFavorites() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(favoriteMovies)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }
}
