//
//  iOSViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class iOSViewControllerFactoryTest: XCTestCase {
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    let options = ["A1", "A2"]

    func test_questionViewController_singleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: Question.singleAnswer("Q1")).title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: singleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController().options, options)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithSingleSelection() {
        XCTAssertFalse(makeQuestionController().allowsMultipleSelection)
    }
    
    func test_questionViewController_singleAnswer_rightCallbackWasFired() {
        var callbackFired = false
        let sut = makeQuestionController(answerCallback: { _ in
            callbackFired = true
        })
        _ = sut.view
        sut.tableview.select(row: 0)
        XCTAssertTrue(callbackFired)
    }
    
    func test_questionViewController_multipleAnswer_rightCallbackWasFired() {
        var callbackFired = false
        let sut = makeQuestionController(question:Question.multipleAnswer(""), answerCallback: { _ in
            callbackFired = true
        })
        _ = sut.view
        sut.tableview.select(row: 0)
        XCTAssertTrue(callbackFired)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithTitle() {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: multipleAnswerQuestion)
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).title, presenter.title)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithQuestion() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q1")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).options, options)
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithMultipleSelection() {
        XCTAssertTrue(makeQuestionController(question: multipleAnswerQuestion).allowsMultipleSelection)
    }

    func test_resultViewController_createsControllerWithTitle() {
        let results = makeResults()
        
        XCTAssertEqual(results.controller.title, results.presenter.title)
    }
    
    func test_resultViewController_createsControllerWithSummary() {
        let results = makeResults()
        
        XCTAssertEqual(results.controller.summary, results.presenter.summary)
    }
    
    func test_resultViewController_createsControllerWithPresentableAnswers() {
        let results = makeResults()
        
        XCTAssertEqual(results.controller.answers.count, results.presenter.presentableAnswers.count)
    }
    
    // MARK: Helpers
    
    func makeSUT(options: Dictionary<Question<String>, [String]> = [:], correctAnswers: [Question<String>: [String]] = [:]) -> iOSViewControllerFactory {
        return iOSViewControllerFactory(questions:[singleAnswerQuestion, multipleAnswerQuestion], options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer(""), answerCallback: @escaping ([String]) -> Void = {_ in}) -> QuestionViewController {
        let sut = makeSUT(options: [question: options])

        return sut.questionViewController(question: question, answerCallback: answerCallback) as! QuestionViewController
    }
    
    func makeResults() -> (controller: ResultViewController, presenter: ResultsPresenter) {
        
        let userAnswers = [singleAnswerQuestion:["A1"], multipleAnswerQuestion:["A2","A3"]]
        let correctAnswers = [singleAnswerQuestion:["A1"], multipleAnswerQuestion:["A2","A3"]]
        let questions = [singleAnswerQuestion, multipleAnswerQuestion]
        let result = Result(answers: userAnswers, score: 2)
        
        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        let sut = makeSUT(correctAnswers: correctAnswers)

        let controller = sut.resultViewController(for: result) as! ResultViewController
        
        return (controller, presenter)
    }
}
