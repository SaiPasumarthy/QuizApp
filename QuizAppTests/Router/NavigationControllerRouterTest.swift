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
    
    func test_routeToQuestion_showsQuestionController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, viewController: viewController)
        factory.stub(question: Question.singleAnswer("Q2"), viewController: secondViewController)
        
        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in })
        sut.routeTo(question: Question.singleAnswer("Q2"), answerCallback: { _ in })

        XCTAssertEqual(navigationController.viewControllers.count, 2)
        XCTAssertEqual(navigationController.viewControllers.first, viewController)
        XCTAssertEqual(navigationController.viewControllers.last, secondViewController)
    }
    
    func test_routeToQuestion_singleAnswer_doesNotConfiguresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: singleAnswerQuestion, viewController: viewController)

        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in })
        
        factory.answerCallback[singleAnswerQuestion]!(["A1"])
        
        XCTAssertNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_singleAnswer_progressToTheNextQuestion() {
        var callbackFired = false
        sut.routeTo(question: singleAnswerQuestion, answerCallback: { _ in callbackFired = true })
        
        factory.answerCallback[singleAnswerQuestion]!(["A1"])
        
        XCTAssertTrue(callbackFired)
    }
    
    func test_routeToQuestion_multipleAnswer_doesnotProgressToTheNextQuestion() {
        var callbackFired = false
        sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in callbackFired = true })
        
        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        
        XCTAssertFalse(callbackFired)
    }
    
    func test_routeToQuestion_multipleAnswer_configuresViewControllerWithSubmitButton() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, viewController: viewController)

        sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in })
        
        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        
        XCTAssertNotNil(viewController.navigationItem.rightBarButtonItem)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_disabledWhenZeroAnswersSelected() {
        let viewController = UIViewController()
        factory.stub(question: multipleAnswerQuestion, viewController: viewController)

        sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in })
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)

        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        XCTAssertTrue(viewController.navigationItem.rightBarButtonItem!.isEnabled)
        
        factory.answerCallback[multipleAnswerQuestion]!([])
        XCTAssertFalse(viewController.navigationItem.rightBarButtonItem!.isEnabled)
    }
    
    func test_routeToQuestion_multipleAnswerSubmitButton_progressToNextQuestion() {
        let viewController = UIViewController()
        var callbackFired = false
        
        factory.stub(question: multipleAnswerQuestion, viewController: viewController)

        sut.routeTo(question: multipleAnswerQuestion, answerCallback: { _ in callbackFired = true })

        factory.answerCallback[multipleAnswerQuestion]!(["A1"])
        viewController.navigationItem.rightBarButtonItem?.simulateTap()
        XCTAssertTrue(callbackFired)
    }
    
    func test_routeToResult_showsResultController() {
        let viewController = UIViewController()
        let secondViewController = UIViewController()

        let result = Result.make(answers: [singleAnswerQuestion: ["A1"]], score: 1)
        let secondResult = Result.make(answers: [Question.singleAnswer("Q2"): ["A2"]], score: 2)

        factory.stub(result: result, viewController: viewController)
        factory.stub(result: secondResult, viewController: secondViewController)
        
        sut.routeTo(result: result)
        sut.routeTo(result: secondResult)

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
        private var stubbedResults = Dictionary<Result<Question<String>, [String]>, UIViewController>()

        var answerCallback = Dictionary<Question<String>, ([String]) -> Void>()
        
        func stub(question: Question<String>, viewController: UIViewController) {
            stubbedQuestions[question] = viewController
        }
        
        func stub(result: Result<Question<String>, [String]>, viewController: UIViewController) {
            stubbedResults[result] = viewController
        }
        
        func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
            self.answerCallback[question] = answerCallback
            return stubbedQuestions[question] ?? UIViewController()
        }
        
        func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
            return stubbedResults[result] ?? UIViewController()
        }
    }
}

private extension UIBarButtonItem {
    func simulateTap() {
        target!.perform(self.action!, on: .main, with: nil, waitUntilDone: true)
    }
}
