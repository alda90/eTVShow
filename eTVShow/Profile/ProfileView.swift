//
//  ProfileView.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 27/12/22.
//

import UIKit
import Combine

/////////////////////// HOME VIEW PROTOCOL
protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// HOME VIEW
///////////////////////////////////////////////////////////////////////////////////////////////////

class ProfileView: UIViewController {
    
    private lazy var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor(named: "principal")
        lbl.font = UIFont.boldSystemFont(ofSize: 24.0)
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
        lbl.text = "Profile"
        return lbl
    }()
    
    var presenter: ProfilePresenterProtocol?

    private var subscriptions = Set<AnyCancellable>()
    private let presenterInput: ProfilePresenterInput = ProfilePresenterInput()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
        presenterInput.loadTVShows.send(1)
    }
    
}

private extension ProfileView {
    
    func bind() {
        let output = presenter?.bind(input: presenterInput)
        
        output?.profileDataPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success(let data):
//                    if !(self?.presenter?.pagination ?? false) {
//                        self?.collectionView.setContentOffset(.zero, animated: false)
//                    }
//                    self?.collectionAdapter.updateSnapshot(tvShows: data)
                    break
                case .failure(let error):
                    self?.presentAlert("We are sorry, and error has ocurred!", message: error.localizedDescription)
                }
            }).store(in: &subscriptions)
    }
    
    func setupView() {
        view.backgroundColor = UIColor(named: "background")
        
        view.addSubview(lblTitle)
        NSLayoutConstraint.activate([
            
            lblTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            lblTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lblTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)

//            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//
//            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            footerView.heightAnchor.constraint(equalToConstant: 44),
//            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    
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

extension ProfileView: ProfileViewProtocol { }
