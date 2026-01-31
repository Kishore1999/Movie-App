//
//  TrailerPlayerView.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct TrailerPlayerView: View {
    let videoKey: String

    private var thumbnailURL: URL? {
        URL(string: "https://img.youtube.com/vi/\(videoKey)/hqdefault.jpg")
    }

    private var youtubeURL: URL? {
        URL(string: "https://www.youtube.com/watch?v=\(videoKey)")
    }

    var body: some View {
        ZStack {
            // Thumbnail
            AsyncImage(url: thumbnailURL) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.black)
                        .overlay { ProgressView().tint(.white) }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Rectangle()
                        .fill(Color.black)
                        .overlay {
                            Image(systemName: "play.rectangle")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    Rectangle()
                        .fill(Color.black)
                }
            }

            // Play button overlay
            Button {
                if let url = youtubeURL {
                    UIApplication.shared.open(url)
                }
            } label: {
                Circle()
                    .fill(Color.red)
                    .frame(width: 70, height: 70)
                    .overlay {
                        Image(systemName: "play.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .offset(x: 3)
                    }
                    .shadow(radius: 5)
            }
        }
        .clipped()
    }
}

#Preview {
    TrailerPlayerView(videoKey: "dQw4w9WgXcQ")
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 12))
}
