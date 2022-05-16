//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 26/04/22.
//

import UIKit
import QuizEngine

final class NavigationControllerRouter: QuizDelegate {
    
    private let naviagationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.naviagationController = navigationController
        self.factory = factory
    }
    
    func answer(for question: Question<String>, completion: @escaping ([String]) -> Void) {
        switch question {
        case .singleAnswer:
            show(factory.questionViewController(question: question, answerCallback: completion))
        case .multipleAnswer:
            let barButton = UIBarButtonItem(title: "Submit", style: .done, target: nil, action: nil)
            let buttonController = SubmitButtonController(button: barButton, callback: completion)
            let controller = factory.questionViewController(question: question, answerCallback: { selection in
                buttonController.update(model: selection)
            })

            controller.navigationItem.rightBarButtonItem = barButton
            show(controller)
        }
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: Question<String>, answer: [String])]) {
        show(factory.resultViewController(for: answers))
    }
    
    private func show(_ viewController: UIViewController) {
        naviagationController.pushViewController(viewController, animated: true)
    }
}


private class SubmitButtonController: NSObject {
    private let button: UIBarButtonItem
    private let callback: ([String]) -> Void
    private var model: [String] = []
    init(button: UIBarButtonItem, callback: @escaping ([String]) -> Void) {
        self.button = button
        self.callback = callback
        super.init()
        self.setup()
    }
    
    private func setup() {
        self.button.target = self
        self.button.action = #selector(fireCallback)
        updateButtonState()
    }
    
    @objc private func fireCallback() {
        callback(model)
    }
    
    private func updateButtonState() {
        button.isEnabled = model.count > 0
    }
    
    func update(model: [String]) {
        self.model = model
        updateButtonState()
    }
}
