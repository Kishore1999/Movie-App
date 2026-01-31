//
//  MovieRowView.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    @EnvironmentObject var favoritesManager: FavoritesManager

    private var posterURL: URL? {
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: APIConstants.posterBaseURL + posterPath)
    }

    private var releaseYear: String {
        guard let releaseDate = movie.releaseDate, releaseDate.count >= 4 else {
            return "N/A"
        }
        return String(releaseDate.prefix(4))
    }

    private var isFavorite: Bool {
        favoritesManager.isFavorite(movie)
    }

    var body: some View {
        HStack(spacing: 12) {
            // Poster
            AsyncPosterImage(
                url: posterURL,
                width: 60,
                height: 90,
                cornerRadius: 6
            )

            // Movie Info
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title ?? "Unknown Title")
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 12) {
                    RatingView(rating: movie.voteAverage ?? 0, iconSize: 10, fontSize: 12)

                    Text(releaseYear)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Favorite Button
            Button {
                favoritesManager.toggleFavorite(movie)
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor(isFavorite ? .red : .gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let sampleMovie = Movie(
        adult: false,
        backdropPath: nil,
        genreIDS: [28, 12],
        id: 1,
        originalLanguage: "en",
        originalTitle: "Sample Movie",
        overview: "This is a sample movie overview.",
        popularity: 100.0,
        posterPath: "/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        releaseDate: "2024-01-15",
        title: "Sample Movie",
        video: false,
        voteAverage: 8.5,
        voteCount: 1000
    )

    MovieRowView(movie: sampleMovie)
        .padding()
        .environmentObject(FavoritesManager())
}
