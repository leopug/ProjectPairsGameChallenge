//
//  ScoreViewModel.swift
//  ProjectPairsGameChallenge
//
//  Created by Ana Caroline de Souza on 01/04/20.
//  Copyright © 2020 Ian e Leo Corp. All rights reserved.
//

import Foundation
import Combine

class ScoreViewModel {
        
    @Published var score: Int = 6
    var cancellable: AnyCancellable?

    @objc func reduceScore() {
        score-=2
    }

    
    
}
