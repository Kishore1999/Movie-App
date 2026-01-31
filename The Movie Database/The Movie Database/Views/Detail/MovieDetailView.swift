//
//  MovieDetailView.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @StateObject private var viewModel = MovieDetailViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    FavoriteButton(movie: movie, size: .large)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .background(Color.black)
            .task {
                await viewModel.fetchMovieDetails(movieId: movie.id ?? 0)
            }
    }

    @ViewBuilder
    private var content: some View {
        if let movieDetail = viewModel.movieDetail {
            movieDetailContent(movie: movieDetail)
        } else if let error = viewModel.error {
            ErrorView(message: error.localizedDescription) {
                Task {
                    await viewModel.fetchMovieDetails(movieId: movie.id ?? 0)
                }
            }
        } else {
            LoadingView(message: "Loading details...")
        }
    }

    private func movieDetailContent(movie movieDetail: MovieDetail) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Section
                heroSection(movie: movieDetail)

                // Movie Info Section
                movieInfoSection(movie: movieDetail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                // Action Buttons
                actionButtons
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                // Overview
                if let overview = movieDetail.overview, !overview.isEmpty {
                    overviewSection(overview: overview)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                }

                // Genres
                if let genres = movieDetail.genres, !genres.isEmpty {
                    genresSection(genres: genres)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                }

                // Cast Section
                if !viewModel.topCast.isEmpty {
                    castSection
                        .padding(.top, 24)
                }

                Spacer(minLength: 40)
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.black)
    }

    // MARK: - Hero Section
    private func heroSection(movie: MovieDetail) -> some View {
        GeometryReader { geo in
            ZStack {
                CachedAsyncImage(url: movie.backdropURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width,
                               height: geo.size.height)
                        .clipped()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }

                LinearGradient(
                    colors: [.clear, .black.opacity(0.85), .black],
                    startPoint: .top,
                    endPoint: .bottom
                )

                if let trailer = viewModel.trailer, let key = trailer.key {
                    Button {
                        YouTubeHelper.openVideo(key: key)
                    } label: {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 70, height: 70)
                            .overlay {
                                Image(systemName: "play.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .offset(x: 3)
                            }
                            .overlay {
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            }
                    }
                }
            }
        }
        .frame(height: 300)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Movie Info

    private func movieInfoSection(movie: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            Text(movie.title ?? "Unknown Title")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // Meta info row
            HStack(spacing: 8) {
                // Match percentage (based on vote average)
                let matchPercent = Int((movie.voteAverage ?? 0) * 10)
                Text("\(matchPercent)% Match")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)

                // Year
                if let year = movie.releaseYear {
                    Text(year)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Runtime
                if let runtime = movie.formattedRuntime {
                    Text(runtime)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                // Rating badge
                RatingBadge(rating: movie.voteAverage ?? 0)
            }

            // Tagline
            if let tagline = movie.tagline, !tagline.isEmpty {
                Text(tagline)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.top, 4)
            }
        }
    }

    // MARK: - Action Buttons

    private var actionButtons: some View {
        Button {
            if let trailer = viewModel.trailer, let key = trailer.key {
                YouTubeHelper.openVideo(key: key)
            }
        } label: {
            HStack {
                Image(systemName: "play.fill")
                Text("Play Trailer")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }

    // MARK: - Overview

    private func overviewSection(overview: String) -> some View {
        Text(overview)
            .font(.subheadline)
            .foregroundColor(.white.opacity(0.9))
            .lineSpacing(4)
    }

    // MARK: - Genres

    private func genresSection(genres: [Genre]) -> some View {
        Text(genres.map { $0.name }.joined(separator: " • "))
            .font(.caption)
            .foregroundColor(.gray)
    }

    // MARK: - Cast Section

    private var castSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cast")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.topCast) { member in
                        CastCard(member: member)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Supporting Views

struct RatingBadge: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "star.fill")
                .font(.caption2)
            Text(String(format: "%.1f", rating))
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(.yellow)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

struct CastCard: View {
    let member: CastMember

    var body: some View {
        VStack(spacing: 8) {
            CachedAsyncImage(url: member.profileURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    }
            }
            .frame(width: 70, height: 70)
            .clipShape(Circle())

            VStack(spacing: 2) {
                Text(member.name ?? "Unknown")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(member.character ?? "")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(width: 80)
        }
    }
}

#Preview {
    let sampleMovie = Movie(
        adult: false,
        backdropPath: nil,
        genreIDS: [28, 12],
        id: 550,
        originalLanguage: "en",
        originalTitle: "Fight Club",
        overview: "A depressed man suffering from insomnia meets a strange soap salesman.",
        popularity: 100.0,
        posterPath: nil,
        releaseDate: "1999-10-15",
        title: "Fight Club",
        video: false,
        voteAverage: 8.4,
        voteCount: 1000
    )

    MovieDetailView(movie: sampleMovie)
        .environmentObject(FavoritesManager())
}
