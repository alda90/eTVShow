//
//  HomeView.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 23/12/22.
//

import UIKit
import Combine

/////////////////////// LOGIN VIEW PROTOCOL
protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
}

class HomeView: UIViewController {
    var presenter: HomePresenterProtocol?

    private var subscriptions = Set<AnyCancellable>()
    private let presenterInput: HomePresenterInput = HomePresenterInput()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
}
private extension HomeView {
    
    func bind() {
        let output = presenter?.bind(input: presenterInput)
        
        output?.homeDataPublisher
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let data):
                    //self?.fillWithData(viewData: viewData)
                    break
                case .failure(let error):
                    self?.presentAlert("We are sorry, and error has ocurred!", message: error.localizedDescription)
                }
            }).store(in: &subscriptions)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(named: "background")
        title = "TV Shows"
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "iconMenu"), style: .plain, target: self, action: #selector(didTapMenu))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func didTapMenu() {
        
    }
    
    func presentAlert(_ title: String, message: String) {
        self.openAlert(title: title,
                       message: message,
                       alertStyle: .alert,
                       actionTitles: ["Ok"],
                       actionStyles: [.default],
                       actions: [ {_ in
            print("Ok")
        },])
    }
}

extension HomeView: HomeViewProtocol { }
