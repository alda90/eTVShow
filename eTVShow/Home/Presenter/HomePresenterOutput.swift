//
//  HomePresenterOutput.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation
import Combine

struct HomePresenterOutput {
    let homeDataPublisher = PassthroughSubject<Result<[TVShow], Error>, Never>()
}

