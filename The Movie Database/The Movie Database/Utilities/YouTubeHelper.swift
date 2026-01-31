//
//  YouTubeHelper.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import UIKit

enum YouTubeHelper {
    /// Opens a YouTube video by its key.
    /// Tries YouTube app first, falls back to Safari.
    static func openVideo(key: String) {
        let youtubeAppURL = URL(string: "youtube://watch?v=\(key)")
        let youtubeWebURL = URL(string: "https://www.youtube.com/watch?v=\(key)")

        if let appURL = youtubeAppURL, UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = youtubeWebURL {
            UIApplication.shared.open(webURL)
        }
    }
}
