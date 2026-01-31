//
//  MovieCredits.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

struct MovieCredits: Codable {
    let id: Int?
    let cast: [CastMember]?
    let crew: [CrewMember]?
}

// MARK: - CastMember
struct CastMember: Codable, Identifiable, Hashable {
    let id: Int
    let adult: Bool?
    let gender: Int?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case id, adult, gender, name, popularity, character, order
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castId = "cast_id"
        case creditId = "credit_id"
    }

    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: APIConstants.profileBaseURL + profilePath)
    }
}

// MARK: - CrewMember
struct CrewMember: Codable, Identifiable, Hashable {
    let id: Int
    let adult: Bool?
    let gender: Int?
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let creditId: String?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case id, adult, gender, name, popularity, department, job
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case creditId = "credit_id"
    }

    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: APIConstants.profileBaseURL + profilePath)
    }
}
