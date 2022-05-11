//
//  ResultsPresenterTest.swift
//  QuizAppTests
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class ResultsPresenterTest: XCTestCase {
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q2")
    
    func test_title_rendersFormattedTitle() {
        XCTAssertEqual(makeSUT().title, "Result")
    }
    
    func test_summary_withTwoQuestionScoresOne_returnsSummary() {
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A1", "A2"])]
        let correctAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A2"])]
        
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers, score: 1)
        XCTAssertEqual(sut.summary, "You got 1/2 correct")
    }
    
    func test_presentableAnswers_empty_isEmpty() {
        XCTAssertEqual(makeSUT().presentableAnswers.count, 0)
    }
    
    func test_presentableAnswers_withWrongSingleAnswer_mapsAnswer() {
        
        let userAnswers = [(singleAnswerQuestion, ["A1"])]
        let correctAnswers = [(singleAnswerQuestion,["A2"])]
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)
        
        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1")
    }
    
    func test_presentableAnswers_withWrongMultipleAnswer_mapsAnswer() {
        
        let userAnswers = [(singleAnswerQuestion, ["A1","A4"])]
        let correctAnswers = [(singleAnswerQuestion,["A2","A3"])]
        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 1)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2, A3")
        XCTAssertEqual(sut.presentableAnswers.first!.wrongAnswer, "A1, A4")
    }
    
    func test_presentableAnswers_withTwoQuestions_mapsOrderedAnswer() {

        let userAnswers = [(singleAnswerQuestion, ["A2"]), (multipleAnswerQuestion, ["A1","A4"])]
        let correctAnswers = [(singleAnswerQuestion,["A2"]), (multipleAnswerQuestion, ["A1","A4"])]

        let sut = makeSUT(userAnswers: userAnswers, correctAnswers: correctAnswers)

        XCTAssertEqual(sut.presentableAnswers.count, 2)
        XCTAssertEqual(sut.presentableAnswers.first!.question, "Q1")
        XCTAssertEqual(sut.presentableAnswers.first!.answer, "A2")
        XCTAssertNil(sut.presentableAnswers.first!.wrongAnswer)
        
        XCTAssertEqual(sut.presentableAnswers.last!.question, "Q2")
        XCTAssertEqual(sut.presentableAnswers.last!.answer, "A1, A4")
        XCTAssertNil(sut.presentableAnswers.last!.wrongAnswer)
    }
    
    private func makeSUT(userAnswers: ResultsPresenter.Answers = [], correctAnswers: ResultsPresenter.Answers = [], score: Int = 0) -> ResultsPresenter {
        return ResultsPresenter(userAnswers: userAnswers, correctAnswers: correctAnswers, scorer: {_, _ in score})
    }
}
