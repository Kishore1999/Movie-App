//
//  EmptyStateView.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct EmptyStateView: View {
    var icon: String = "film"
    var title: String = "No Movies Found"
    var message: String? = nil

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundColor(.gray)

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        icon: "magnifyingglass",
        title: "No Results",
        message: "Try searching for a different movie"
    )
}
