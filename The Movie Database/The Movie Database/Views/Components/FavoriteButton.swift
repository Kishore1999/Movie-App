//
//  FavoriteButton.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct FavoriteButton: View {
    let movie: Movie
    @EnvironmentObject var favoritesManager: FavoritesManager

    var size: Size = .small

    enum Size {
        case small  // For movie cards (14pt icon, 26px button)
        case large  // For detail view (16pt icon, 32px button)

        var iconSize: CGFloat {
            switch self {
            case .small: return 14
            case .large: return 16
            }
        }

        var buttonSize: CGFloat {
            switch self {
            case .small: return 26
            case .large: return 32
            }
        }
    }

    private var isFavorite: Bool {
        favoritesManager.isFavorite(movie)
    }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                favoritesManager.toggleFavorite(movie)
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundColor(isFavorite ? .red : .white)
                .scaleEffect(isFavorite ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5), value: isFavorite)
                .frame(width: size.buttonSize, height: size.buttonSize)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
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
        posterPath: nil,
        releaseDate: "2024-01-15",
        title: "Sample Movie",
        video: false,
        voteAverage: 8.5,
        voteCount: 1000
    )

    HStack(spacing: 20) {
        FavoriteButton(movie: sampleMovie, size: .small)
        FavoriteButton(movie: sampleMovie, size: .large)
    }
    .padding()
    .background(Color.gray)
    .environmentObject(FavoritesManager())
}
