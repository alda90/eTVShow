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
    var isPaginating: Bool { get set }
    var pagination: Bool { get set }
    
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
    var isPaginating: Bool = false
    var pagination: Bool = false
    private var tvshows = [TVShow]()
    private var page = 1
    
    private var subscriptions = Set<AnyCancellable>()
    
    func bind(input: HomePresenterInput) -> HomePresenterOutput {
        input.loadTVShows.sink { [weak self] load in
            self?.pagination = load.1
            self?.getTVShows(index: load.0)
        }.store(in: &self.subscriptions)
        
        input.goToProfile.sink { [weak self] in
            self?.goToProfile()
        }.store(in: &self.subscriptions)
        
        input.logOut.sink { [weak self] in
            self?.logOut()
        }.store(in: &self.subscriptions)
        
        return output
    }
    
}

extension HomePresenter: HomeInteractorOutputProtocol {
    
    func getTVShows(index: Int) {
        if pagination {
            page += 1
            isPaginating = true
        } else {
            page = 1
        }
        let pageString = String(describing: page)
        
        switch index {
        case 0:
            interactor?.getTvShows(typeService: .getPopular(page: pageString))
        case 1:
            interactor?.getTvShows(typeService: .getTopRated(page: pageString))
        case 2:
            interactor?.getTvShows(typeService: .getOnAir(page: pageString))
        case 3:
            interactor?.getTvShows(typeService: .getAiringToday(page: pageString))
        default:
            break
        }
        
    }
    
    func interactorGetDataPresenter(receivedData: TVResponse?, error: Error?) {
        isPaginating = false
        if !pagination {
            tvshows = []
        }
        if let error = error {
            output.homeDataPublisher.send(.failure(error))
        } else if let data = receivedData {
            tvshows.append(contentsOf: data.tvshows)
            output.homeDataPublisher.send(.success(tvshows))
        }
    }
    
    
    func goToProfile() {
        router?.goToProfile(from: view!)
    }
    
    func logOut() {
        removeFromKeychain()
        Defaults.shared.user = ""
        Defaults.shared.name = ""
        Defaults.shared.avatar = ""
        Defaults.shared.account = 0
        Defaults.shared.session = ""
        router?.logOut(from: view!)
    }
    
    private func removeFromKeychain() {
        do {
            try KeychainManager.remove(service: NetworkRouter.service, account: Defaults.shared.user)
        } catch {
            print(error)
        }
    }
}
