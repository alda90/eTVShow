//
//  HomeInteractor.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation

/////////////////////// HOME INTERACTOR PROTOCOLS
protocol HomeInteractorOutputProtocol: AnyObject {
    func interactorGetDataPresenter(receivedData: TVResponse?, error: Error?)
}

protocol HomeInteractorInputProtocol {
    var presenter: HomeInteractorOutputProtocol? { get set }
    func getTvShows(typeService: NetworkRouter)
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME INTERACTOR
///////////////////////////////////////////////////////////////////////////////////////////////////

class HomeInteractor: HomeInteractorInputProtocol {
    
    weak var presenter: HomeInteractorOutputProtocol?
    
    func getTvShows(typeService: NetworkRouter) {
        
        NetworkManager.shared.request(networkRouter: typeService) { [weak self] (result: NetworkResult<TVResponse>) in
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
