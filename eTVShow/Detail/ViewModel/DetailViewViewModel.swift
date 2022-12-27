//
//  DetailViewViewModel.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import Foundation
import SwiftUI

class DetailViewViewModel: ObservableObject {
    @Published var tvShow: TVShow?
    @Published var castShow: [Cast]?
    
    func loadData(id: Int) {
        debugPrint(Defaults.shared.session)
        debugPrint(Defaults.shared.account)
        NetworkManager.shared.request(networkRouter: NetworkRouter.getDetailTVShow(id: id)) { [weak self] (result: NetworkResult<TVShow>) in
            switch result {
            case .success(let response):
                self?.tvShow = response
                break
            case .failure(let error):
                break
            }
        }
    }
    
    func loadCredits(id: Int) {
        NetworkManager.shared.request(networkRouter: NetworkRouter.getCredits(id: id)) { [weak self] (result: NetworkResult<CastResponse>) in
            switch result {
            case .success(data: let response):
                debugPrint(response.cast)
                self?.castShow = response.cast
            case .failure(let error):
                break
            }
        }
    }
    
    func markFavorite(mediaId: Int, favorite: Bool) {
        let account = Defaults.shared.account
        let sessionId = Defaults.shared.session
        let body = getBody(mediaId, favorite)
        
        NetworkManager.shared.request(networkRouter: NetworkRouter.markFavorite(id: account, sessionId: sessionId, body: body) ) { [weak self] (result: NetworkResult<FavoriteResponse>) in
            switch result {
            case .success(data: let response):
                debugPrint(response.success)
            case .failure(let error):
                break
            }
        }
    }
    
    private func getBody(_ mediaId: Int, _ favorite: Bool) -> Data {
        let body = [
            "media_type" : "tv",
            "media_id" : mediaId,
            "favorite" : favorite
        ] as [String : Any]

        let bodyData = try? JSONSerialization.data(withJSONObject: body)

        return bodyData ?? Data()
    }
}
