//
//  Cast.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import Foundation

// MARK: - CastResponse
struct CastResponse: Codable {
    let cast: [Cast]
    let id: Int
}

// MARK: - Cast
struct Cast: Codable {
    let gender: Int?
    let id: Int
    let name: String?
    let profilePath: String?
    let character: String?
    let creditID: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case gender, id
        case name
        case profilePath = "profile_path"
        case character
        case creditID = "credit_id"
        case order
    }
    
    func profilePathURL() -> URL? {
        let urlString = "\(TVShow.baseURLImageString)\(profilePath ?? "")"
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
}
