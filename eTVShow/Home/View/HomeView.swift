//
//  HomeView.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 23/12/22.
//

import UIKit
import Combine

/////////////////////// HOME VIEW PROTOCOL
protocol HomeViewProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME VIEW
///////////////////////////////////////////////////////////////////////////////////////////////////
class HomeView: UIViewController {
    var presenter: HomePresenterProtocol?

    private var subscriptions = Set<AnyCancellable>()
    private let presenterInput: HomePresenterInput = HomePresenterInput()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var collectionAdapter: ComposableSection = {
        let adapter = ComposableSection(collectionView: collectionView, viewController: self)
        return adapter
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        presenterInput.loadTVShows.send(.getPopular)
    }
}
private extension HomeView {
    
    func bind() {
        let output = presenter?.bind(input: presenterInput)
        let outputAdapter = collectionAdapter.bind()
        
        output?.homeDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.collectionAdapter.updateSnapshot(tvShows: data.tvshows)
                    break
                case .failure(let error):
                    self?.presentAlert("We are sorry, and error has ocurred!", message: error.localizedDescription)
                }
            }).store(in: &subscriptions)
        
        outputAdapter.callToAction
            .sink { [weak self] tvShow in
                
            }
            .store(in: &subscriptions)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(named: "background")
        title = "TV Shows"
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "iconMenu"), style: .plain, target: self, action: #selector(didTapMenu))
        navigationItem.rightBarButtonItem = barButtonItem
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        collectionAdapter.setupCollectionView()
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
