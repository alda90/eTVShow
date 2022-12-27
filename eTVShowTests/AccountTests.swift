//
//  AccountTests.swift
//  eTVShowTests
//
//  Created by Aldair Carrillo on 27/12/22.
//

import XCTest
@testable import eTVShow

final class AccountTests: XCTestCase {
    
    func testRequestToken() {
        let expectation = self.expectation(description: "token")

        var response: TokenResponse?
        
        NetworkManager.shared.request(networkRouter: NetworkRouter.getToken) { (result: NetworkResult<TokenResponse>) in
                switch result {
                case .success(let resp):
                    response = resp
                default:
                    break
                }
                
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
            
        XCTAssertEqual(response?.success , true)
        XCTAssertNotNil(response)
    }
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////
    ///These tests won't run correctly, due they neee the request_token from previuos test, REQUEST TOKEN
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func testSessionWithLogin() {
        let expectation = self.expectation(description: "login")
        
        let body = [
            "username" : "alda_904",
            "password" : "th3m0v13db",
            "request_token" : "fd7905aad4b6a15d6d7861ff0169200e9bf94306"
        ]

        let bodyData = try? JSONSerialization.data(withJSONObject: body)

        var response: TokenResponse?
        
        NetworkManager.shared.request(networkRouter: NetworkRouter.sessionLogin(body: bodyData ?? Data())) { (result: NetworkResult<TokenResponse>) in
                switch result {
                case .success(let resp):
                    response = resp
                default:
                    break
                }
                
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
            
        XCTAssertEqual(response?.success , true)
        XCTAssertNotNil(response)
    }

    
    func testCreateSession() {
        let expectation = self.expectation(description: "session")
        
        let body = [
            "request_token" : "7bb431d2ad1f528a6d79d93358f70e524f90074f"
        ]

        let bodyData = try? JSONSerialization.data(withJSONObject: body)

        var response: TokenResponse?
        
        NetworkManager.shared.request(networkRouter: NetworkRouter.createSession(body: bodyData ?? Data())) { (result: NetworkResult<TokenResponse>) in
                switch result {
                case .success(let resp):
                    response = resp
                default:
                    break
                }
                
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
            
        XCTAssertEqual(response?.success , true)
        XCTAssertNotNil(response)
    }
    
    func testGetAccountDetail() {
        let expectation = self.expectation(description: "account")
        
        let sessionId = "028a58cdc350d5d179c12634a7b556fff5e8812f"

        var response: Account?
        
        NetworkManager.shared.request(networkRouter: NetworkRouter.accountDetail(sessionId: sessionId)) { (result: NetworkResult<Account>) in
                switch result {
                case .success(let resp):
                    response = resp
                default:
                    break
                }
                
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
            
        XCTAssertEqual(response?.username, "alda_904")
        XCTAssertNotNil(response)
    }

}
