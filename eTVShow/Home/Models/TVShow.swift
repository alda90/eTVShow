//
//  TVShow.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 25/12/22.
//
import Foundation

// MARK: - TVResponse
struct TVResponse: Codable {
    let page: Int
    let tvshows: [TVShow]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case tvshows = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct TVShow: Codable, Hashable {
    let backdropPath: String?
    let firstAirDate: String?
    let genreIDS: [Int]?
    let id: Int
    var name: String
    let originCountry: [String]?
    let originalLanguage: String?
    let originalName: String?
    let overview: String?
    let popularity: Double?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    private static let baseURLImageString = "https://image.tmdb.org/t/p/w500"
    
    func posterPathURL() -> URL? {
        let urlString = "\(TVShow.baseURLImageString)\(posterPath ?? "")"
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    func formattedReleasedDate() -> String {
        if let firstAirDate = firstAirDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MMM d, yyyy"
            
            return newDateFormatter.string(from: dateFormatter.date(from: firstAirDate ) ?? Date())
        }
        
        return ""
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }

    static func == (lhs: TVShow, rhs: TVShow) -> Bool {
      return lhs.identifier == rhs.identifier
    }

    private let identifier = UUID()
}
