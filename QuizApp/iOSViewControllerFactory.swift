//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    private let questions: [Question<String>]
    private let options: Dictionary<Question<String>, [String]>
    private let correctAnswers: Dictionary<Question<String>, [String]>

    init(questions: [Question<String>],options: Dictionary<Question<String>, [String]>, correctAnswers: [Question<String>: [String]]) {
        self.questions = questions
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("View couldn't be loaded with no options")
        }
        
        return questionViewController(question: question, options: options, answerCallback: answerCallback)
    }
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        let presenter = ResultsPresenter(result: result, questions: questions, correctAnswers: correctAnswers)
        return ResultViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
    }
    
    private func questionViewController(question: Question<String>, options: [String], answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {

        switch question {
        case .singleAnswer(let value):
            return questionViewController(question: question, value: value, options: options, allowsMultipleSelection: false, answerCallback: answerCallback)
        case .multipleAnswer(let value):
            return questionViewController(question: question, value: value, options: options, allowsMultipleSelection: true, answerCallback: answerCallback)
        }
    }
    
    private func questionViewController(question: Question<String>, value: String, options: [String], allowsMultipleSelection: Bool, answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(question: value, options: options, allowsMultipleSelection: allowsMultipleSelection, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }
}
