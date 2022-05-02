//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import Foundation
@testable import QuizEngine

extension Result: Hashable {
    
    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result {
        return Result(answers: answers, score: score)
    }
    
    public var hashValue: Int {
        return 1
    }
    
    public static func ==(lhs:Result<Question, Answer>, rhs:Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
}
