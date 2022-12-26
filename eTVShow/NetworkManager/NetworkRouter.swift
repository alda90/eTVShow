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
//        case .getVideos: return .get
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
//        case .getVideos(let id):
//            return "/\(id)/videos"
        }
    }
    
    func request() throws -> URLRequest {
        let urlString = "\(NetworkRouter.baseURLString)\(path)"
        
        guard let baseURL = URL(string: urlString),
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
                else { throw NetworkErrorType.parseUrlFail }
    
        components.queryItems = [URLQueryItem(name: "api_key", value: NetworkRouter.apiKey)]
        
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
