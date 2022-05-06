//
//  BasicScore.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 06/05/22.
//

import Foundation

class BasicScore {
    static func score<T: Equatable>(for answers: [T], compareTo correctAnswers: [T]) -> Int {
        return zip(answers, correctAnswers).reduce(0) { score, tuple in
            return score + (tuple.0 == tuple.1 ? 1 : 0)
        }
    }
}
