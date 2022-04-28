//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import Foundation
import QuizEngine

struct ResultsPresenter {
    var summary: String {
        return "You got \(result.score)/\(result.answers.count) correct"
    }
    
    let result: Result<Question<String>, [String]>
    let correctAnswers: [Question<String>: [String]]
    
    var presentableAnswers: [PresentableAnswer] {
        return result.answers.map { (question, userAnswer) in
            guard let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn't find correct answer for question \(question)")
            }
            
            return presentableAnswer(question, userAnswer, correctAnswer)
        }
    }
    
    private func presentableAnswer(_  question: Question<String>, _ userAnswer: [String], _ correctAnswer: [String])-> PresentableAnswer {
        switch question {
        case .singleAnswer(let value), .multipleAnswer(let value):
            return PresentableAnswer(question: value, answer: formattedCorrectAnswer(correctAnswer), wrongAnswer: wrongAnswer(userAnswer, correctAnswer))
        }
    }
    
    private func formattedCorrectAnswer(_ answer: [String]) -> String {
        return answer.joined(separator: ", ")
    }
    
    private func wrongAnswer(_ userAnswer: [String], _ correctAnswer: [String]) -> String? {
        return correctAnswer == userAnswer ? nil : formattedCorrectAnswer(userAnswer)
    }
}
