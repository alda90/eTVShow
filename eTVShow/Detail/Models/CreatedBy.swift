//
//  CreatedBy.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import Foundation

// MARK: - CreatedBy
struct CreatedBy: Codable {
    let id: Int
    let creditID: String?
    let name: String?
    let gender: Int?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name, gender
        case profilePath = "profile_path"
    }
}
