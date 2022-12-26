//
//  NetworkManager.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// MARK: This singleton pattern could be seems safe.
/// Another solution is to set the request in a URLSession extension
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class NetworkManager {
    static let shared = NetworkManager()
    
    private let config: URLSessionConfiguration
    private let session: URLSession
    
    private init() {
        config = URLSessionConfiguration.default
        session = URLSession(configuration: config)
    }
    
    func request<T: Decodable> (networkRouter: NetworkRouter, completion: @escaping (NetworkResult<T>) -> ()) {
        do {
            let task = try session.dataTask(with: networkRouter.request()) { (data, response, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        completion(NetworkResult<T>.failure(error: error))
                        return
                    }
                    
                    guard let statusCode = response?.getStatuscode(), (200...299).contains(statusCode) else {
                        let errorType: NetworkErrorType = .invalidResponse
                        
                        completion(NetworkResult<T>.failure(error: errorType))
                        return
                    }
                    
                    guard let data = data else {
                        completion(NetworkResult<T>.failure(error: NetworkErrorType.dataError))
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completion(NetworkResult.success(data: result))
                    } catch let error {
                        completion(NetworkResult.failure(error: error))
                    }
                }
            }
            
            task.resume()
            
        } catch let error {
            completion(NetworkResult<T>.failure(error: error))
        }
    }
}

extension URLResponse {
    func getStatuscode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
