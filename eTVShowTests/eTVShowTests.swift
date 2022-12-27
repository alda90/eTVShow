//
//  eTVShowTests.swift
//  eTVShowTests
//
//  Created by Aldair Carrillo on 23/12/22.
//

import XCTest
@testable import eTVShow

final class eTVShowTests: XCTestCase {

    func testGetPopularTVShows() {
        let expectation = self.expectation(description: "tvshows")
            
        var movieResponse: TVResponse?
        
        NetworkManager.shared.request(networkRouter: NetworkRouter.getPopular(page: "1")) { (result: NetworkResult<TVResponse>) in
            switch result {
            case .success(let movieResp):
                movieResponse = movieResp
            default:
                break
            }
            
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 10, handler: nil)
            
        XCTAssertNotNil(movieResponse)
    }

}
