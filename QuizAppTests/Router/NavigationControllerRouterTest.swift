//
//  NavigationControllerRouterTest.swift
//  QuizAppTests
//
//  Created by Sai Pasumarthy on 26/04/22.
//

import UIKit
import Foundation
import XCTest
import QuizEngine
@testable import QuizApp

class NavigationControllerRouterTest: XCTestCase {
    let singleAnswerQuestion = Question.singleAnswer("Q1")
    let multipleAnswerQuestion = Question.multipleAnswer("Q1")
    
    let navigationController = NonAnimatedNavigationController()
    let factory = ViewControllerFactoryStub()
    lazy var sut: NavigationControllerRouter = {
        return NavigationControllerRouter(self.navigationController, factory: self.factory)
    }()
    
    func test_answerForQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, viewController: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), viewController: secondViewController)
        
        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        sut.answer(for: Question.singleAnswer("Q2"), completion: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_answerForQuestion_singleAnswer_doesNotConfiguresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, viewController: viewController)

        sut.answer(for: singleAnswerQuestion, completion: { _ in })
        
        factory.answerCallback[singleAnswerQuestion]!(["A1"])
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_singleAnswer_progressToTheNextQuestion() {
        var callbackFired = false
        sut.answer(for: singleAnswerQuestion, completion: { _ in callbackFired = true })
        
        factory.answerCallback[singleAnswerQuestion]!(["A1"])
        
        XCTAssertTrue(callbackFired)
    }
    
    func test_answerForQuestion_multipleAnswer_doesnotProgressToTheNextQuestion() {
        var callbackFired = false
        sut.answer(for: multipleAnswerQuestion, completion: { _ in callbackFired = true })
        
        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        
        XCTAssertFalse(callbackFired)
    }
    
    func test_answerForQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, viewController: viewController)

        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        
        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_answerForQuestion_multipleAnswerSubmitButton_disabledWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, viewController: viewController)

        sut.answer(for: multipleAnswerQuestion, completion: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)

        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswerQuestion]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_answerForQuestion_multipleAnswerSubmitButton_progressToNextQuestion() {
        let viewController = UIViewController()
        var callbackFired = false
        
        factory.stub(question: multipleAnswerQuestion, viewController: viewController)

        sut.answer(for: multipleAnswerQuestion, completion: { _ in callbackFired = true })

        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        viewController.navigationItem.rightBarButtonItem?.simulateTap()
        XCTAssertTrue(callbackFired)
    }
    
    func test_didCompleteQuiz_showsResultController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()

        let result = [(singleAnswerQuestion, ["A1"])]
        let secondResult = [(Question.singleAnswer("Q2"), ["A2"])]
        
        factory.stub(resultForQuestions: [singleAnswerQuestion], viewController: viewController)
        factory.stub(resultForQuestions: [Question.singleAnswer("Q2")], viewController: secondViewController)
        
        sut.didCompleteQuiz(withAnswers: result)
        sut.didCompleteQuiz(withAnswers: secondResult)

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    // MARK: Helpers
    
    class NonAnimatedNavigationController: UINavigationController {
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: false)
        }
    }
    
    class ViewControllerFactoryStub: ViewControllerFactory {
        private var stubbedQuestions = Dictionary<Question<String>, UIViewController>()
        private var stubbedResults = Dictionary<[Question<String>], UIViewController>()

        var answerCallback = Dictionary<Question<String>, ([String]) -> Void>()
        
        func stub(question: Question<String>, viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(resultForQuestions questions: [Question<String>], viewController: UIViewController) {
            stubbedResults[questions] = viewController
        }
        
        func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for userAnswers: Answers) -> UIViewController {
            return stubbedResults[userAnswers.map { $0.question }] ?? UIViewController()
        }
    }
}

private extension UIBarButtonItem {
    func simulateTap() {
        target!.perform(self.action!, on: .main, with: nil, waitUntilDone: true)
    }
}
