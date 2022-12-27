//
//  LoginInteractor.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 23/12/22.
//

import Foundation

/////////////////////// LOGIN INTERACTOR PROTOCOLS
protocol LoginInteractorOutputProtocol: AnyObject {
    func interactorGetDataPresenter(receivedData: TokenResponse?, error: Error?)
}

protocol LoginInteractorInputProtocol {
    var presenter: LoginInteractorOutputProtocol? { get set }
    func login(user: String, password: String)
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// LOGIN INTERACTOR
///////////////////////////////////////////////////////////////////////////////////////////////////

class LoginInteractor: LoginInteractorInputProtocol {
    
    weak var presenter: LoginInteractorOutputProtocol?
    private var user: String?
    
    func login(user: String, password: String) {
        NetworkManager.shared.request(networkRouter: .getToken) { [weak self] (result: NetworkResult<TokenResponse>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.success {
                    self.user = user
                    self.sessionLogin(body: self.getBody(user, password, requestToken: response.requestToken))
                } else {
                    self.loginError(error: NetworkErrorType.serverError)
                }
            case .failure(error: let error):
                self.loginError(error: error)
            }
        }
    }
    
    private func loginError(error: Error) {
        presenter?.interactorGetDataPresenter(receivedData: nil, error: error)
    }
    
    private func sessionLogin(body: Data) {
        
        NetworkManager.shared.request(networkRouter: .sessionLogin(body: body)) { [weak self] (result: NetworkResult<TokenResponse>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.success {
                    self.saveInKeychain(account: self.user ?? "", key: response.requestToken)
                    self.createSessionId(body: self.getBodySession(response.requestToken))
                } else {
                    self.loginError(error: NetworkErrorType.serverError)
                }
            case .failure(error: let error):
                self.loginError(error: error)
            }
        }
    }
    
    private func createSessionId(body: Data) {
        NetworkManager.shared.request(networkRouter: .createSession(body: body)) { [weak self] (result: NetworkResult<TokenResponse>) in
            switch result {
            case .success(let response):
                if response.success {
                    if let sessionId = response.session_id {
                        Defaults.shared.session = sessionId
                        self?.getAccountDetail(sessionId: sessionId, response: response)
                    }
                } else {
                    self?.loginError(error: NetworkErrorType.serverError)
                }
            case .failure(error: let error):
                self?.loginError(error: error)
            }
        }
    }
    
    private func getAccountDetail(sessionId: String, response: TokenResponse) {
        NetworkManager.shared.request(networkRouter: .accountDetail(sessionId: sessionId)) { [weak self] (result: NetworkResult<Account>) in
            switch result {
            case .success(let account):
                Defaults.shared.account = account.id
                Defaults.shared.avatar = account.avatar?.tmdb?.avatarPath ?? ""
                Defaults.shared.name = account.name ?? ""
                self?.presenter?.interactorGetDataPresenter(receivedData: response, error: nil)
            case .failure(error: let error):
                self?.loginError(error: error)
            }
        }
    }
    
    private func getBody(_ user: String, _ password: String, requestToken: String?) -> Data {
        let body = [
            "username" : user,
            "password" : password,
            "request_token" : requestToken
        ]

        let bodyData = try? JSONSerialization.data(withJSONObject: body)

        return bodyData ?? Data()
    }

    private func getBodySession(_ requestToken: String?) -> Data {
        let body = [
            "request_token" : requestToken
        ]
        
        let bodyData = try? JSONSerialization.data(withJSONObject: body)
        
        return bodyData ?? Data()
    }
    
    private func saveInKeychain(account: String, key: String?) {
        Defaults.shared.user = account
        guard let key = key else { return }
        
        do {
            try KeychainManager.save(service: NetworkRouter.service, account: account, key: key.data(using: .utf8) ?? Data())
        } catch {
            print(error)
        }
    }
    
}



