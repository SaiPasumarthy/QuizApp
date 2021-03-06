//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 28/04/22.
//

import Foundation
import QuizEngine

struct QuestionPresenter {
    let questions: [Question<String>]
    let question: Question<String>
    
    var title: String {
        guard let index = questions.firstIndex(of: question) else { return "" }
        
        return "\(index + 1) of \(questions.count)"
    }
}
