//
//  HomePresenter.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation
import Combine

/////////////////////// HOME PRESENTER PROTOCOL
protocol HomePresenterProtocol: AnyObject {
    var view: HomeViewProtocol? { get set }
    var interactor: HomeInteractorInputProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    
    func bind(input: HomePresenterInput) -> HomePresenterOutput
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME PRESENTER
///////////////////////////////////////////////////////////////////////////////////////////////////

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    var interactor: HomeInteractorInputProtocol?
    var router: HomeRouterProtocol?
    var output: HomePresenterOutput = HomePresenterOutput()
    
    private var subscriptions = Set<AnyCancellable>()
    

    func bind(input: HomePresenterInput) -> HomePresenterOutput {
        input.loadTVShows.sink { [weak self] type in
            
        }.store(in: &self.subscriptions)
        
        return output
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    
    func interactorGetDataPresenter(receivedData: TokenResponse?, error: Error?) {
        //output.homeDataPublisher.send()
    }
    
}
