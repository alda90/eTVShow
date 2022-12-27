//
//  HomePresenterInput.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation
import Combine

struct HomePresenterInput {
    let loadTVShows = PassthroughSubject<(Int, Bool), Never>()
    let goToProfile = PassthroughSubject<Void, Never>()
    let logOut = PassthroughSubject<Void, Never>()
}
