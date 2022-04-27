//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 26/04/22.
//

import UIKit
import QuizEngine

class NavigationControllerRouter: Router {
    
    private let naviagationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ naviagationController: UINavigationController, factory: ViewControllerFactory) {
        self.naviagationController = naviagationController
        self.factory = factory
    }
    
    func routeTo(question: Question<String>, answerCallback: @escaping (String) -> Void) {
        show(factory.questionViewController(question: question, answerCallback: answerCallback))
    }
    
    func routeTo(result:Result<Question<String>, String>) {
        show(factory.resultViewController(for: result))
    }
    
    private func show(_ viewController: UIViewController) {
        naviagationController.pushViewController(viewController, animated: true)
    }
}
