//
//  MoviesListViewModel.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation
import Combine

@MainActor
final class MoviesListViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: APIError?
    @Published var searchQuery = ""

    // MARK: - Computed Properties

    var isSearching: Bool { !searchQuery.isEmpty }

    // MARK: - Private Properties

    private var currentPage = 1
    private var totalPages = 1
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        setupSearchDebounce()
    }

    // MARK: - Private Methods

    private func setupSearchDebounce() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                Task {
                    await self.performSearch(query: query)
                }
            }
            .store(in: &cancellables)
    }

    private func performSearch(query: String) async {
        if query.isEmpty {
            await fetchPopularMovies()
        } else {
            await searchMovies(query: query)
        }
    }

    // MARK: - Public Methods

    func fetchPopularMovies() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil
        currentPage = 1

        let result = await NetworkManager.shared.fetchPopularMovies(page: currentPage)

        switch result {
        case .success(let data):
            movies = data.movie ?? []
            totalPages = data.totalPages ?? 1
        case .failure(let apiError):
            error = apiError
            movies = []
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentMovie: Movie) async {
        guard let lastMovie = movies.last,
              lastMovie.id == currentMovie.id,
              currentPage < totalPages,
              !isLoading else { return }

        currentPage += 1
        isLoading = true

        let result: Result<MovieListData, APIError>

        if isSearching {
            result = await NetworkManager.shared.searchMovies(query: searchQuery, page: currentPage)
        } else {
            result = await NetworkManager.shared.fetchPopularMovies(page: currentPage)
        }

        switch result {
        case .success(let data):
            movies.append(contentsOf: data.movie ?? [])
        case .failure(let apiError):
            error = apiError
            currentPage -= 1
        }

        isLoading = false
    }

    private func searchMovies(query: String) async {
        guard !isLoading else { return }

        movies = []
        isLoading = true
        error = nil
        currentPage = 1

        let result = await NetworkManager.shared.searchMovies(query: query, page: currentPage)

        switch result {
        case .success(let data):
            movies = data.movie ?? []
            totalPages = data.totalPages ?? 1
        case .failure(let apiError):
            error = apiError
            movies = []
        }

        isLoading = false
    }

    func clearError() {
        error = nil
    }
}
