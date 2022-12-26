//
//  LoginPresenterInput.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 24/12/22.
//

import Foundation
import Combine

struct LoginPresenterInput {
    let tapToLogin = PassthroughSubject<(String, String), Never>()
}

