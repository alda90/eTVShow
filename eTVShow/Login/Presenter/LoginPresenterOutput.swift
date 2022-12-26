//
//  LoginPresenterOutput.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation
import Combine

struct LoginPresenterOutput {
    let loginDataErrorPublisher = PassthroughSubject<Error, Never>()
}

