//
//  CastListView.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct CastListView: View {
    let cast: [CastMember]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Cast")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(cast) { member in
                        CastMemberCard(member: member)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct CastMemberCard: View {
    let member: CastMember

    var body: some View {
        VStack(spacing: 8) {
            AsyncImage(url: member.profileURL) { phase in
                switch phase {
                case .empty:
                    placeholderView
                        .overlay { ProgressView() }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    placeholderView
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                        }
                @unknown default:
                    placeholderView
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())

            VStack(spacing: 2) {
                Text(member.name ?? "Unknown")
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)

                Text(member.character ?? "")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(width: 80)
        }
    }

    private var placeholderView: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 80, height: 80)
    }
}

#Preview {
    let sampleCast = [
        CastMember(id: 1, adult: false, gender: 2, knownForDepartment: "Acting", name: "Tom Hanks", originalName: "Tom Hanks", popularity: 50.0, profilePath: nil, castId: 1, character: "Forrest Gump", creditId: "123", order: 0),
        CastMember(id: 2, adult: false, gender: 1, knownForDepartment: "Acting", name: "Robin Wright", originalName: "Robin Wright", popularity: 40.0, profilePath: nil, castId: 2, character: "Jenny Curran", creditId: "124", order: 1)
    ]

    CastListView(cast: sampleCast)
}
