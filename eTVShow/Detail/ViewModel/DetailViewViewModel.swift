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
}
