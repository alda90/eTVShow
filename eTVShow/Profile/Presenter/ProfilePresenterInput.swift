//
//  ProfilePresenterInput.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 27/12/22.
//

import Foundation
import Combine

struct ProfilePresenterInput {
    let loadTVShows = PassthroughSubject<Void, Never>()
}
