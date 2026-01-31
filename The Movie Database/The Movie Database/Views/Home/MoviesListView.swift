//
//  MoviesListView.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct MoviesListView: View {
    @StateObject private var viewModel = MoviesListViewModel()

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Popular Movies")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $viewModel.searchQuery, prompt: "Search movies...")
                .task {
                    if viewModel.movies.isEmpty {
                        await viewModel.fetchPopularMovies()
                    }
                }
        }
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.isSearching && viewModel.movies.isEmpty {
            // Shimmer skeleton for search loading
            SkeletonGrid(columns: columns)
        } else if viewModel.isLoading && viewModel.movies.isEmpty {
            LoadingView(message: "Loading movies...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
        } else if let error = viewModel.error, viewModel.movies.isEmpty {
            ErrorView(message: error.localizedDescription) {
                Task {
                    await viewModel.fetchPopularMovies()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
        } else if viewModel.movies.isEmpty {
            EmptyStateView(
                icon: "magnifyingglass",
                title: "No Movies Found",
                message: viewModel.searchQuery.isEmpty ? nil : "Try searching for a different movie"
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
        } else {
            moviesGrid
        }
    }

    private var moviesGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(viewModel.movies, id: \.id) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MoviePosterCard(movie: movie)
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        Task {
                            await viewModel.loadMoreIfNeeded(currentMovie: movie)
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)

            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .padding(.vertical, 20)
            }

            Spacer(minLength: 40)
        }
        .background(Color.black)
        .scrollIndicators(.hidden)
    }
}

// MARK: - Movie Poster Card

struct MoviePosterCard: View {
    let movie: Movie
    @EnvironmentObject var favoritesManager: FavoritesManager

    private var posterURL: URL? {
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: APIConstants.posterBaseURL + posterPath)
    }

    private var isFavorite: Bool {
        favoritesManager.isFavorite(movie)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Poster Image
            CachedAsyncImage(url: posterURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .aspectRatio(2/3, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(2/3, contentMode: .fit)
                    .overlay {
                        ProgressView()
                            .tint(.white)
                    }
            }

            // Favorite Heart Button
            FavoriteButton(movie: movie, size: .small)
                .padding(6)
        }
        .contextMenu {
            // Play Trailer
            Button {
                Task {
                    await playTrailer()
                }
            } label: {
                Label("Play Trailer", systemImage: "play.fill")
            }

            // Add/Remove Favorite
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                    favoritesManager.toggleFavorite(movie)
                }
            } label: {
                Label(
                    isFavorite ? "Remove from Favorites" : "Add to Favorites",
                    systemImage: isFavorite ? "heart.slash.fill" : "heart"
                )
            }
        }
    }

    // MARK: - Play Trailer

    private func playTrailer() async {
        let result = await NetworkManager.shared.fetchMovieVideos(id: movie.id ?? 0)
        if case .success(let videos) = result,
           let trailer = videos.results?.first(where: { $0.type == "Trailer" && $0.site == "YouTube" }),
           let key = trailer.key {
            await MainActor.run {
                YouTubeHelper.openVideo(key: key)
            }
        }
    }
}

#Preview {
    MoviesListView()
        .environmentObject(FavoritesManager())
}
