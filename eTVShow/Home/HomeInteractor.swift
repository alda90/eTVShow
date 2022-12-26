//
//  HomeInteractor.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation

/////////////////////// HOME INTERACTOR PROTOCOLS
protocol HomeInteractorOutputProtocol: AnyObject {
    func interactorGetDataPresenter(receivedData: TokenResponse?, error: Error?)
}

protocol HomeInteractorInputProtocol {
    var presenter: HomeInteractorOutputProtocol? { get set }
    func getTvShows()
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME INTERACTOR
///////////////////////////////////////////////////////////////////////////////////////////////////

class HomeInteractor: HomeInteractorInputProtocol {
    
    weak var presenter: HomeInteractorOutputProtocol?
    
    func getTvShows() {
        
    }
    
}
