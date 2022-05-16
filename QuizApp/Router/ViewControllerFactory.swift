//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import UIKit
import QuizEngine

protocol ViewControllerFactory {
    typealias Answers = [(question:Question<String>, answer: [String])]
    
    func questionViewController(question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    func resultViewController(for userAnswers: Answers) -> UIViewController
}
