//
//  QuestionTest.swift
//  QuizAppTests
//
//  Created by Sai Pasumarthy on 26/04/22.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionTest: XCTestCase {
    
    func test_hashValue_singleAnswer_returnTypeHashValue() {
        let type = "a string"
        let sut = Question.singleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_hashValue_multipleAnswer_returnTypeHashValue() {
        let type = "a string"
        let sut = Question.multipleAnswer(type)
        
        XCTAssertEqual(sut.hashValue, type.hashValue)
    }
    
    func test_equal_isEqual() {
        XCTAssertEqual(Question.singleAnswer("a string"), Question.singleAnswer("a string"))
        XCTAssertEqual(Question.multipleAnswer("a string"), Question.multipleAnswer("a string"))
    }
    
    func test_notEqual_isNotEqual() {
        XCTAssertNotEqual(Question.singleAnswer("a string"), Question.singleAnswer("a another string"))
        XCTAssertNotEqual(Question.multipleAnswer("a string"), Question.multipleAnswer("a another string"))
        XCTAssertNotEqual(Question.singleAnswer("a string"), Question.multipleAnswer("a another string"))
        XCTAssertNotEqual(Question.singleAnswer("a string"), Question.multipleAnswer("a string"))
    }

}

