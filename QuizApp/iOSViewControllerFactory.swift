//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    private let options: Dictionary<Question<String>, [String]>
    
    init(options: Dictionary<Question<String>, [String]>) {
        self.options = options
    }
    
    func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("View couldn't be loaded with no options")
        }
        
        return questionViewController(question: question, options: options, answerCallback: answerCallback)
    }
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        return UIViewController()
    }
    
    private func questionViewController(question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {

        switch question {
        case .singleAnswer(let value):
            return QuestionViewController(question: value, options: options, selection: {_ in })
        case .multipleAnswer(let value):
            let controller = QuestionViewController(question: value, options: options, selection: {_ in })
            _ = controller.view
            controller.tableview.allowsMultipleSelection = true
            return controller
        }
    }
}
