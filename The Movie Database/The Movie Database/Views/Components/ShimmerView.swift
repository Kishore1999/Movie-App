//
//  ShimmerView.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct ShimmerView: View {
    @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)

    private let gradientColors = [
        Color.gray.opacity(0.2),
        Color.gray.opacity(0.4),
        Color.gray.opacity(0.2)
    ]

    var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: startPoint,
            endPoint: endPoint
        )
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                startPoint = .init(x: 1, y: 1)
                endPoint = .init(x: 2.8, y: 2.2)
            }
        }
    }
}

// MARK: - Skeleton Poster Card

struct SkeletonPosterCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .aspectRatio(2/3, contentMode: .fit)
            .overlay {
                ShimmerView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Skeleton Grid

struct SkeletonGrid: View {
    let columns: [GridItem]
    let count: Int

    init(columns: [GridItem], count: Int = 9) {
        self.columns = columns
        self.count = count
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(0..<count, id: \.self) { _ in
                    SkeletonPosterCard()
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
        }
        .background(Color.black)
        .scrollIndicators(.hidden)
    }
}

#Preview {
    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    SkeletonGrid(columns: columns)
}
