//
//  AsyncPosterImage.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct AsyncPosterImage: View {
    let url: URL?
    var width: CGFloat = 100
    var height: CGFloat = 150
    var cornerRadius: CGFloat = 8

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                placeholderView
                    .overlay {
                        ProgressView()
                    }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                placeholderView
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            @unknown default:
                placeholderView
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var placeholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: width, height: height)
    }
}

#Preview {
    AsyncPosterImage(url: URL(string: "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg"))
}
