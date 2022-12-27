//
//  EpisodeViewModel.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 27/12/22.
//

import Foundation
import SwiftUI

class EpisodeViewModel: ObservableObject {
    @Published var episodes: [Int : [Episode]] = [:]
    
    func loadEpisdos(id: Int, seasonNumber: Int) {
        debugPrint(Defaults.shared.session)
        NetworkManager.shared.request(networkRouter: NetworkRouter.getEpisodes(id: id, seasonNumber: seasonNumber)) { [weak self] (result: NetworkResult<EpisodeResponse>) in
            switch result {
            case .success(let response):
                self?.episodes.updateValue(response.episodes, forKey: seasonNumber)
                break
            case .failure(let error):
                break
            }
        }
    }
    
}

