//
//  Genre.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

struct Genre: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}
