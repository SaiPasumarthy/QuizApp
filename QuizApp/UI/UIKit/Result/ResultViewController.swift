//
//  ResultViewController.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 23/04/22.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private(set) var summary: String = ""
    private(set) var answers: [PresentableAnswer] = []
    
    convenience init(summary: String, answers: [PresentableAnswer]) {
        self.init()
        self.summary = summary
        self.answers = answers
    }
    
    override func viewDidLoad() {
        headerLabel.text = summary
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CorrectAnswerCell.self)
        tableView.register(WrongAnswerCell.self)
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let answer = answers[indexPath.row]
        if answer.wrongAnswer == nil {
            return correctAnswerCell(answer: answer)
        }
        return wrongAnswerCell(answer: answer)
    }
    
    private func correctAnswerCell(answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(CorrectAnswerCell.self)!
        cell.questionLabel.text = answer.question
        cell.answerLabel.text = answer.answer
        return cell
    }
    
    private func wrongAnswerCell(answer: PresentableAnswer) -> UITableViewCell {
        let cell = tableView.dequeReusableCell(WrongAnswerCell.self)!
        cell.questionLabel.text = answer.question
        cell.correctAnswerLabel.text = answer.answer
        cell.wrongAnswerLabel.text = answer.wrongAnswer
        return cell
    }
}

extension ResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return answers[indexPath.row].wrongAnswer == nil ? 70 : 90
    }
}
