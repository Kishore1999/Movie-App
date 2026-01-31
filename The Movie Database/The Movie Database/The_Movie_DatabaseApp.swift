//
//  The_Movie_DatabaseApp.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import SwiftUI

@main
struct The_Movie_DatabaseApp: App {
    @StateObject private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(favoritesManager)
        }
    }
}
