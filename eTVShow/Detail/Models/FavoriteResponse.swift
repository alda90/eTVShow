//
//  FavoriteResponse.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 27/12/22.
//

import Foundation

struct FavoriteResponse: Codable {
    let success: Bool
    let statusCode: Int?
    let statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
