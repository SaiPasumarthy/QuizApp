//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import Foundation
import QuizEngine

extension Result: Hashable {
    
    public var hashValue: Int {
        return 1
    }
    
    public static func ==(lhs:Result<Question, Answer>, rhs:Result<Question, Answer>) -> Bool {
        return lhs.score == rhs.score
    }
}
