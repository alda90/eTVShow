//
//  ComposableSectionOutput.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 26/12/22.
//

import Foundation
import Combine

struct ComposableSectionOutput {
    let callToAction = PassthroughSubject<TVShow, Never>()
    let fetchData = PassthroughSubject<Void, Never>()
}
