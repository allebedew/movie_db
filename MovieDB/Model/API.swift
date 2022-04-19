//
//  MovieDBAPI.swift
//  MovieDB
//
//  Created by Alex on 19.04.2022.
//

import Foundation
import Combine

struct TVShowListResponse: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [TVShow]
}

struct TVShow: Codable {
    let id: Int
    let name: String
    let originalName: String
    let overview: String
    let firstAirDate: Date
    let genreIds: [Int]
    let posterPath: String
    let backdropPath: String
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
}

final class MovieDBAPI {
    
    static let shard = MovieDBAPI()
    
    public func fetchPopularTVShows() -> AnyPublisher<TVShowListResponse, Error> {
        
        let req = urlRequest(path: "/3/tv/popular", query: ["api_key": apiKey])
        
        return session.dataTaskPublisher(for: req)
            .map { $0.data }
            .decode(type: TVShowListResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .print()
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private let apiKey = "557e01397b0129c0a37aed7de29ccefc"
    private let baseURL = URL(string: "https://api.themoviedb.org/3/")!
    
    let session: URLSession
    let decoder: JSONDecoder
    
    init() {
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func urlRequest(path: String, query: [String: String]) -> URLRequest {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "api.themoviedb.org"
        url.path = path
        url.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let request = URLRequest(url: url.url!)
        return request
    }
}

final class Network {
    
    func runRequest() {
        
    }
    
}
