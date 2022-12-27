//
//  Episode.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 27/12/22.
//

import Foundation

// MARK: - EpisodeResponse
struct EpisodeResponse: Codable {
    let episodes: [Episode]
}

// MARK: - Episode
struct Episode: Codable {
    let episodeNumber, id: Int
    let name: String?
    let overview: String?
    let stillPath: String?

    enum CodingKeys: String, CodingKey {
        case episodeNumber = "episode_number"
        case id, name, overview
        case stillPath = "still_path"
    }
    
    func stillPathURL() -> URL? {
        let urlString = "\(TVShow.baseURLImageString)\(stillPath ?? "")"
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
}
