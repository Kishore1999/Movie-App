//
//  APIEndpoint.swift
//  The Movie Database
//
//  Created by Kishore on 31/01/26.
//

import Foundation

enum APIEndpoint {
    case popular(page: Int)
    case movieDetail(id: Int)
    case movieCredits(id: Int)
    case movieVideos(id: Int)
    case search(query: String, page: Int)

    var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .movieDetail(let id):
            return "/movie/\(id)"
        case .movieCredits(let id):
            return "/movie/\(id)/credits"
        case .movieVideos(let id):
            return "/movie/\(id)/videos"
        case .search:
            return "/search/movie"
        }
    }

    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem(name: "api_key", value: APIConstants.apiKey)]

        switch self {
        case .popular(let page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        case .movieDetail, .movieCredits, .movieVideos:
            break
        case .search(let query, let page):
            items.append(URLQueryItem(name: "query", value: query))
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        }

        return items
    }

    var url: URL? {
        var components = URLComponents(string: APIConstants.baseURL + path)
        components?.queryItems = queryItems
        return components?.url
    }
}
