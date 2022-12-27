//
//  NetworkRouter.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation

enum NetworkRouter {
    case getToken
    case sessionLogin(body: Data)
    case createSession(body: Data)
    case getPopular(page: String)
    case getTopRated(page: String)
    case getOnAir(page: String)
    case getAiringToday(page: String)
    case getDetailTVShow(id: Int)
    case getCredits(id: Int)
    case getEpisodes(id: Int, seasonNumber: Int)
    
    private static let baseURLString = "https://api.themoviedb.org/3"
    private static let apiKey = "608cfab9393cf6de1a420e80a1c19ffb"
    static let service = "themoviedb.org"
    
    private enum HTTTPMethod {
        case get
        case post
        
        var value: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            }
        }
    }
    
    private var method: HTTTPMethod {
        switch self {
        case .getToken: return .get
        case .sessionLogin: return .post
        case .createSession: return .post
        case .getPopular: return .get
        case .getTopRated: return .get
        case .getOnAir: return .get
        case .getAiringToday: return .get
        case .getDetailTVShow: return .get
        case .getCredits: return .get
        case .getEpisodes: return .get
        }
    }
    
    private var path: String {
        switch self {
        case .getToken:
            return "/authentication/token/new"
        case .sessionLogin:
            return "/authentication/token/validate_with_login"
        case .createSession:
            return "/authentication/session/new"
        case .getPopular:
            return "/tv/popular"
        case .getTopRated:
            return "/tv/top_rated"
        case .getOnAir:
            return "/tv/on_the_air"
        case .getAiringToday:
            return "/tv/airing_today"
        case .getDetailTVShow(let id):
            return "/tv/\(id)"
        case .getCredits(let id):
            return "/tv/\(id)/credits"
        case .getEpisodes(let id, let seasonNumber):
            return "/tv/\(id)/season/\(seasonNumber)"
        }
    }
    
    func request() throws -> URLRequest {
        let urlString = "\(NetworkRouter.baseURLString)\(path)"
        
        guard let baseURL = URL(string: urlString),
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
                else { throw NetworkErrorType.parseUrlFail }
    
        components.queryItems = [
            URLQueryItem(name: "api_key", value: NetworkRouter.apiKey)
        ]
        
        switch self {
        case .getPopular(let page), .getTopRated(let page), .getOnAir(let page), .getAiringToday(let page):
            let query: [URLQueryItem] = [URLQueryItem(name: "page", value: page)]
            components.queryItems?.append(contentsOf: query)
        default:
            break
        }
        
        
        guard let url = components.url else { throw NetworkErrorType.parseUrlFail }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch self {
        case .sessionLogin(let body):
            request.httpBody = body
        case .createSession(let body):
            request.httpBody = body
        default:
            break
        }
        
        return request
    }
}
