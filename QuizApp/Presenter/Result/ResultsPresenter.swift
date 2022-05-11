//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 27/04/22.
//

import Foundation
import QuizEngine

final class ResultsPresenter {
    
    typealias Answers = [(question: Question<String>, answers: [String])]
    typealias Scorer = ([[String]], [[String]]) -> Int
    
    private let userAnswers: Answers
    private let correctAnswers: Answers
    private let scorer: Scorer
    
    init(userAnswers: Answers, correctAnswers: Answers, scorer: @escaping Scorer) {
        self.userAnswers = userAnswers
        self.correctAnswers = correctAnswers
        self.scorer = scorer
    }
    
    init(result: Result<Question<String>, [String]>, questions:[Question<String>], correctAnswers: [Question<String>: [String]]) {
        self.userAnswers = questions.map { question in
            return (question, result.answers[question]!)
        }
        self.correctAnswers = questions.map { question in
            return (question, correctAnswers[question]!)
        }
        self.scorer = {_, _ in return result.score}
    }
    
    var title: String {
        return "Result"
    }
    
    var summary: String {
        return "You got \(score)/\(self.userAnswers.count) correct"
    }
    
    private var score: Int {
        return self.scorer(self.userAnswers.map { $0.answers }, self.correctAnswers.map { $0.answers })
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return zip(self.userAnswers, self.correctAnswers).map { userAnswer, correctAnswer in
            return presentableAnswer(userAnswer.question, userAnswer.answers, correctAnswer.answers)
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
