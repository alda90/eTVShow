//
//  Season.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import Foundation

// MARK: - Season
struct Season: Codable {
    let airDate: String?
    let episodeCount: Int?
    let id: Int
    let name: String
    let overview: String?
    let posterPath: String?
    let seasonNumber: Int?

    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
    
    func posterPathURL() -> URL? {
        let urlString = "\(TVShow.baseURLImageString)\(posterPath ?? "")"
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    func formattedairDate() -> String {
        if let airDate = airDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MMM d, yyyy"
            
            return newDateFormatter.string(from: dateFormatter.date(from: airDate ) ?? Date())
        }
        
        return ""
    }
}
