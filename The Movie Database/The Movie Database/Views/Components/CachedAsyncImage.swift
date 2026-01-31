//
//  CachedAsyncImage.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else {
                placeholder()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        guard let url = url, !isLoading else { return }

        // Check cache first
        if let cachedImage = ImageCache.shared.get(for: url) {
            self.image = cachedImage
            return
        }

        isLoading = true

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let uiImage = UIImage(data: data) {
                    ImageCache.shared.set(uiImage, for: url)
                    await MainActor.run {
                        self.image = uiImage
                        self.isLoading = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}

// MARK: - Image Cache

final class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        // Set up memory cache limits
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB

        // Set up disk cache directory
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")

        // Create directory if needed
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    func get(for url: URL) -> UIImage? {
        // Check memory cache
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }

        // Check disk cache
        let filePath = diskCachePath(for: url)
        if let data = try? Data(contentsOf: filePath),
           let image = UIImage(data: data) {
            // Store in memory cache for faster access
            cache.setObject(image, forKey: url as NSURL)
            return image
        }

        return nil
    }

    func set(_ image: UIImage, for url: URL) {
        // Store in memory cache
        cache.setObject(image, forKey: url as NSURL)

        // Store on disk
        let filePath = diskCachePath(for: url)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: filePath)
        }
    }

    private func diskCachePath(for url: URL) -> URL {
        let filename = url.absoluteString.data(using: .utf8)?.base64EncodedString() ?? UUID().uuidString
        return cacheDirectory.appendingPathComponent(filename)
    }
}

// MARK: - Convenience initializer for poster images

extension CachedAsyncImage where Content == Image, Placeholder == ProgressView<EmptyView, EmptyView> {
    init(url: URL?) {
        self.url = url
        self.content = { $0 }
        self.placeholder = { ProgressView() }
    }
}

#Preview {
    CachedAsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg")) { image in
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
    } placeholder: {
        ProgressView()
    }
    .frame(width: 100, height: 150)
    .clipShape(RoundedRectangle(cornerRadius: 8))
}
