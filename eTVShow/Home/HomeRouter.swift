//
//  HomeRouter.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation
import UIKit

/////////////////////// HOME ROUTER  PROTOCOL
protocol HomeRouterProtocol {
    var presenter: HomePresenterProtocol? { get set }
    static func createHomeModule() -> UIViewController
    func goToDetail(from view: HomeViewProtocol)
    func goToProfile(from view: HomeViewProtocol)
    func logOut(from view: HomeViewProtocol)
}


////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME ROUTER
///////////////////////////////////////////////////////////////////////////////////////////////////
class HomeRouter: HomeRouterProtocol {
    
    var presenter: HomePresenterProtocol?
    
    static func createHomeModule() -> UIViewController {
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /// MARK: I choose this implementation to create every class, but it can be improved
        /// with the builder patter, and adding dependecy injection when the instances are created.
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        let view = HomeView()

        let interactor = HomeInteractor()
        let presenter: HomePresenterProtocol & HomeInteractorOutputProtocol = HomePresenter()
        let router = HomeRouter()

        router.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        presenter.interactor = interactor
        view.presenter = presenter
        presenter.view = view
        
        return view
    }
    
    func goToDetail(from view: HomeViewProtocol) {
        
    }
    
    func goToProfile(from view: HomeViewProtocol) {
        if let vc = view as? UIViewController {
            let homeView = ProfileRouter.createProfileModule()
            vc.present(homeView, animated: true)
        }
    }
    
    func logOut(from view: HomeViewProtocol) {
        if let vc = view as? UIViewController {
            let loginView = LoginRouter.createLoginModule()
            loginView.modalPresentationStyle = .fullScreen
            vc.present(loginView, animated: true)
        }
    }
}
