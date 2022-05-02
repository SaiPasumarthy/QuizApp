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
        guard let index = questions.index(of: question) else { return "" }
        
        return "Question #\(index + 1)"
    }
}
