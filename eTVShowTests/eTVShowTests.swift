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
            
        var tvResponse: TVResponse?
        
        NetworkManager.shared.request(networkRouter: NetworkRouter.getPopular(page: "1")) { (result: NetworkResult<TVResponse>) in
            switch result {
            case .success(let tvResp):
                tvResponse = tvResp
            default:
                break
            }
            
            expectation.fulfill()
        }
            
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertNotNil(tvResponse)
    }
    
    func testGetDetailTVShow() {
        let id = 119051
        let expectation = self.expectation(description: "detail")
        
        var tvShow: TVShow?
        NetworkManager.shared.request(networkRouter: NetworkRouter.getDetailTVShow(id: id)) { (result: NetworkResult<TVShow>) in
                switch result {
                case .success(let tvResp):
                    tvShow = tvResp
                default:
                    break
                }
                
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
            
        XCTAssertEqual(tvShow?.id, id)
        XCTAssertNotNil(tvShow)
    }

    func testGetCreditsTVShow() {
        let id = 119051
        let expectation = self.expectation(description: "credits")
        
        var cast: CastResponse?
        NetworkManager.shared.request(networkRouter: NetworkRouter.getCredits(id: id)) { (result: NetworkResult<CastResponse>) in
                switch result {
                case .success(let castResp):
                    cast = castResp
                default:
                    break
                }
                
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
            
        XCTAssertEqual(cast?.id, id)
        XCTAssertNotNil(cast)
    }
    
    func testGetEpisodesFromSeasonTVShow() {
        let idTvShow = 119051
        let idSeason = 182137
        let seasonNumber = 1
        let expectation = self.expectation(description: "episodes")
        
        var episodes: EpisodeResponse?
        NetworkManager.shared.request(networkRouter: NetworkRouter.getEpisodes(id: idTvShow, seasonNumber: 1)) { (result: NetworkResult<EpisodeResponse>) in
                switch result {
                case .success(let castResp):
                    episodes = castResp
                default:
                    break
                }
                
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
            
        XCTAssertEqual(episodes?.id ?? 0, idSeason)
        XCTAssertEqual(episodes?.seasonNumber ?? 0, seasonNumber)
        XCTAssertNotNil(episodes)
    }
    
    func testMarkFavoriteTVShow() {
        let accountId = 6374815
        let sessionId = "93f2ee0dc27c5aeb756b35574f9cc87294394554"
        let expectation = self.expectation(description: "favorite")
        let body = [
            "media_type" : "tv",
            "media_id" : 119051,
            "favorite" : true
        ] as [String : Any]

        let bodyData = try? JSONSerialization.data(withJSONObject: body)
        
        var response: FavoriteResponse?
        
        NetworkManager.shared.request(networkRouter: NetworkRouter.markFavorite(id: accountId, sessionId: sessionId, body: bodyData ?? Data())) { (result: NetworkResult<FavoriteResponse>) in
                switch result {
                case .success(let favResp):
                    response = favResp
                default:
                    break
                }
                
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10, handler: nil)
            
        XCTAssertEqual(response?.success , true)
        XCTAssertNotNil(response)
    }
}
