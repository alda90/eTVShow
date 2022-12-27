//
//  ProfilePresenterOutput.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 27/12/22.
//

import Foundation
import Combine

struct ProfilePresenterOutput {
    let profileDataPublisher = PassthroughSubject<Result<[TVShow], Error>, Never>()
}
