//
//  iOSSwiftUIViewControllerFactoryTest.swift
//  QuizAppTests
//
//  Created by Sai Pasumarthy on 20/05/22.
//

import SwiftUI
import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class iOSSwiftUIViewControllerFactoryTest: XCTestCase {
    

    func test_questionViewController_singleAnswer_createsControllerWithTitle() throws {
        let presenter = QuestionPresenter(questions: [singleAnswerQuestion, multipleAnswerQuestion], question: singleAnswerQuestion)
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.title, presenter.title)
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithQuestion() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.question, "Q1")
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithOptions() throws {
        let view = try XCTUnwrap(makeSingleAnswerQuestion())
        XCTAssertEqual(view.options, options[singleAnswerQuestion])
    }
    
    func test_questionViewController_singleAnswer_createsControllerWithAnswerCallback() throws {
        var answers = [[String]]()
        
        let view = try XCTUnwrap(makeSingleAnswerQuestion(answerCallback: { answers.append($0) }))
        XCTAssertEqual(answers, [])
        
        view.selection(view.options[0])
        XCTAssertEqual(answers, [[view.options[0]]])
        
        view.selection(view.options[1])
        XCTAssertEqual(answers, [[view.options[0]], [view.options[1]]])
    }
    
    func test_questionViewController_multipleAnswer_rightCallbackWasFired() {
        var callbackFired = false
        let sut = makeQuestionController(question:Question.multipleAnswer("Q2"), answerCallback: { _ in
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
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).question, "Q2")
    }
    
    func test_questionViewController_multipleAnswer_createsControllerWithOptions() {
        XCTAssertEqual(makeQuestionController(question: multipleAnswerQuestion).options, options[multipleAnswerQuestion])
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
    
    private var singleAnswerQuestion: Question<String> { .singleAnswer("Q1") }
    private var multipleAnswerQuestion: Question<String> { .multipleAnswer("Q2") }

    private var questions: [Question<String>] {
        return [singleAnswerQuestion, multipleAnswerQuestion]
    }
    
    private var options: [Question<String>: [String]] {
        return [singleAnswerQuestion : ["A1","A2","A3"], multipleAnswerQuestion:["A4","A5","A6"]]
    }
    
    private var correctAnswers: [(Question<String>, [String])] {
        return [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion,["A4","A5"])]
    }
    
    func makeSUT() -> iOSSwiftUIViewControllerFactory {
        return iOSSwiftUIViewControllerFactory(options: options, correctAnswers: correctAnswers)
    }
    
    func makeQuestionController(question: Question<String> = Question.singleAnswer(""), answerCallback: @escaping ([String]) -> Void = {_ in}) -> QuestionViewController {
        let sut = makeSUT()

        return sut.questionViewController(question: question, answerCallback: answerCallback) as! QuestionViewController
    }
    
    func makeSingleAnswerQuestion(answerCallback: @escaping ([String]) -> Void = {_ in}) -> SingleAnswerQuestion? {
        let sut = makeSUT()

        let controller = sut.questionViewController(question: singleAnswerQuestion, answerCallback: answerCallback) as? UIHostingController<SingleAnswerQuestion>
        return controller?.rootView
    }
    
    func makeResults() -> (controller: ResultViewController, presenter: ResultsPresenter) {
        
        let userAnswers = [(singleAnswerQuestion, ["A1"]), (multipleAnswerQuestion, ["A2","A3"])]
        
        let presenter = ResultsPresenter(userAnswers: userAnswers, correctAnswers: correctAnswers, scorer: BasicScore.score)
        let sut = makeSUT()

        let controller = sut.resultViewController(for: userAnswers) as! ResultViewController
        
        return (controller, presenter)
    }
}
