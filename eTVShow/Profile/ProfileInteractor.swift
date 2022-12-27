//
//  ProfileInteractor.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 27/12/22.
//

import Foundation

/////////////////////// PROFILE INTERACTOR PROTOCOLS
protocol ProfileInteractorOutputProtocol: AnyObject {
    func interactorGetDataPresenter(receivedData: TVResponse?, error: Error?)
}

protocol ProfileInteractorInputProtocol {
    var presenter: ProfileInteractorOutputProtocol? { get set }
    func getTvShows()
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// PROFILE INTERACTOR
///////////////////////////////////////////////////////////////////////////////////////////////////

class ProfileInteractor: ProfileInteractorInputProtocol {
    
    weak var presenter: ProfileInteractorOutputProtocol?
    
    func getTvShows() {
        
        NetworkManager.shared.request(networkRouter: .getPopular(page: "1")) { [weak self] (result: NetworkResult<TVResponse>) in
            switch result {
            case .success(let response):
                self?.presenter?.interactorGetDataPresenter(receivedData: response, error: nil)
                break
            case .failure(error: let error):
                self?.presenter?.interactorGetDataPresenter(receivedData: nil, error: error)
            }
        }
        
    }
    
}
