//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    typealias Answers = [(question:Question<String>, answer: [String])]
    
    private var questions: [Question<String>] {
        return correctAnswers.map { $0.question }
    }
    
    private let options: Dictionary<Question<String>, [String]>
    private let correctAnswers: Answers

    init(options: Dictionary<Question<String>, [String]>, correctAnswers: Answers) {
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("View couldn't be loaded with no options")
        }
        
        return questionViewController(question: question, options: options, answerCallback: answerCallback)
    }
    
    func resultViewController(for userAnswers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(userAnswers: userAnswers, correctAnswers: correctAnswers, scorer: BasicScore.score)
        
        let controller = ResultViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
        controller.title = presenter.title
        return controller
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
