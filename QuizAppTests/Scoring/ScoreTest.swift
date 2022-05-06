//
//  ScoreTest.swift
//  QuizEngine
//
//  Created by Sai Pasumarthy on 06/05/22.
//

import Foundation
import XCTest
@testable import QuizApp

class ScoreTest: XCTestCase {
    
    func test_noAnswers_scoresZero() {
        let score = BasicScore.score(for: [String](), compareTo: [String]())
        XCTAssertEqual(score, 0)
    }
    
    func test_oneNonMatchedAnswer_scoresZero() {
        let score = BasicScore.score(for: ["not a match"], compareTo: ["an answer"])
        XCTAssertEqual(score, 0)
    }
    
    func test_oneCorrectAnswer_scoresOne() {
        let score = BasicScore.score(for: ["an answer"], compareTo: ["an answer"])
        XCTAssertEqual(score, 1)
    }
    
    func test_oneCorrectAnswerOneWrongAnswer_scoresOne() {
        let score = BasicScore.score(for: ["an answer", "not a match"], compareTo: ["an answer", "another answer"])
        XCTAssertEqual(score, 1)
    }
    
    func test_twoCorrectAnswer_scoresTwo() {
        let score = BasicScore.score(for: ["an answer", "another answer"], compareTo: ["an answer", "another answer"])
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyAnswers_twoMatchingAnswers_scoresTwo() {
        let score = BasicScore.score(for: ["an answer", "another answer", "an extra answer"], compareTo: ["an answer", "another answer"])
        XCTAssertEqual(score, 2)
    }
    
    func test_withTooManyCorrectAnswers_oneMatchingAnswer_scoresOne() {
        let score = BasicScore.score(for: ["not matching", "another answer"],
                                     compareTo: ["an answer","another answer", "an extra answer"])
        XCTAssertEqual(score, 1)
    }
}
