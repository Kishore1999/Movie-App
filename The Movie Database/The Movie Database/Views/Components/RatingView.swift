//
//  RatingView.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct RatingView: View {
    let rating: Double
    var iconSize: CGFloat = 12
    var fontSize: CGFloat = 14

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: iconSize))
                .foregroundColor(.yellow)

            Text(String(format: "%.1f", rating))
                .font(.system(size: fontSize, weight: .medium))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    RatingView(rating: 8.5)
}
