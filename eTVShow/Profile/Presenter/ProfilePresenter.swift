//
//  HomePresenter.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 27/12/22.
//

import Foundation
import Combine

/////////////////////// PROFILE PRESENTER PROTOCOL
protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol? { get set }
    var interactor: ProfileInteractorInputProtocol? { get set }
    var router: ProfileRouterProtocol? { get set }
    
    func bind(input: ProfilePresenterInput) -> ProfilePresenterOutput
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// PROFILE PRESENTER
///////////////////////////////////////////////////////////////////////////////////////////////////

class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewProtocol?
    var interactor: ProfileInteractorInputProtocol?
    var router: ProfileRouterProtocol?
    var output: ProfilePresenterOutput = ProfilePresenterOutput()
   
    private var tvshows = [TVShow]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    func bind(input: ProfilePresenterInput) -> ProfilePresenterOutput {
        input.loadTVShows.sink { [weak self] in
            self?.interactor?.getTvShows()
        }.store(in: &self.subscriptions)
        
        return output
    }
    
}

extension ProfilePresenter: ProfileInteractorOutputProtocol {
    
    func interactorGetDataPresenter(receivedData: TVResponse?, error: Error?) {
        if let error = error {
            output.profileDataPublisher.send(.failure(error))
        } else if let data = receivedData {
            tvshows.append(contentsOf: data.tvshows)
            output.profileDataPublisher.send(.success(tvshows))
        }
    }
    
}
