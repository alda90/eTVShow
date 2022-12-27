//
//  HomeView.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 23/12/22.
//

import UIKit
import Combine
import SwiftUI

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
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentItems = ["Popular", "TopRated", "On TV", "Airing Today"]
        let segmented = UISegmentedControl(items: segmentItems)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmented.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmented.selectedSegmentTintColor = UIColor(named: "placeholder")
        segmented.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        return segmented
    }()
    
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
    
    private lazy var footerView: UIView = {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        return footerView
    }()

    private let spinner = UIActivityIndicatorView()
    private let appearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        segmentedControl.selectedSegmentIndex = 0
        loadTVShows(index: 0, paginate: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        appearance.backgroundColor = UIColor(named: "backgroundSplash")
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    override func viewWillDisappear(_ animated: Bool) {
        appearance.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = nil
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

}
private extension HomeView {
    
    func loadTVShows(index: Int, paginate: Bool) {
        presenterInput.loadTVShows.send((index, paginate))
    }
    
    func bind() {
        let output = presenter?.bind(input: presenterInput)
        let outputAdapter = collectionAdapter.bind()
        
        output?.homeDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                self?.spinner.stopAnimating()
                switch result {
                case .success(let data):
                    if !(self?.presenter?.pagination ?? false) {
                        self?.collectionView.setContentOffset(.zero, animated: false)
                    }
                    self?.collectionAdapter.updateSnapshot(tvShows: data)
                    break
                case .failure(let error):
                    self?.presentAlert("We are sorry, and error has ocurred!", message: error.localizedDescription)
                }
            }).store(in: &subscriptions)
        
        outputAdapter.callToAction
            .sink { [weak self] tvShow in
                let swiftUIViewController = UIHostingController(rootView: DetailView(tvShowObject: TVShowObject(tvshow: tvShow), navigationController: self?.navigationController))
                self?.navigationController?.pushViewController(swiftUIViewController, animated: true)
            }
            .store(in: &subscriptions)
        
        outputAdapter.fetchData
            .sink { [weak self] in
                guard let self = self else { return }
                if let presenter = self.presenter,
                   !presenter.isPaginating {
                    self.spinner.startAnimating()
                    let index = self.segmentedControl.selectedSegmentIndex
                    self.loadTVShows(index: index, paginate: true)
                }
        }.store(in: &self.subscriptions)
    }
    
    func setupView() {
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        view.backgroundColor = UIColor(named: "background")
        title = "TV Shows"
        
        let barButtonItem = UIBarButtonItem(image: UIImage(named: "iconMenu"), style: .plain, target: self, action: #selector(didTapMenu))
        navigationItem.rightBarButtonItem = barButtonItem
        
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(footerView)
        view.bringSubviewToFront(footerView)
        NSLayoutConstraint.activate([
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            footerView.heightAnchor.constraint(equalToConstant: 44),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        collectionAdapter.setupCollectionView()
    }
    
    @objc func didTapMenu() {
        showSimpleActionSheet(controller: self)
    }
    
    @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
        loadTVShows(index: segmentedControl.selectedSegmentIndex, paginate: false)
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
    

    func showSimpleActionSheet(controller: UIViewController) {
        let alert = UIAlertController(title: "", message: "What do you want to do?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "View Profile", style: .default, handler: { [weak self] (_) in
            self?.presenterInput.goToProfile.send()
        }))

        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            print("User click Edit button")
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
}

extension HomeView: HomeViewProtocol { }
