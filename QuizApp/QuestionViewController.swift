//
//  QuestionViewController.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 21/04/22.
//

import Foundation
import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    private(set) var question: String = ""
    private(set) var options:[String] = []
    private var selection: (([String]) -> Void)?
    private let reuseIdentifier = "Cell"
    
    convenience init(question: String, options:[String], selection: @escaping ([String]) -> Void) {
        self.init()
        self.question = question
        self.options = options
        self.selection = selection
    }
    
    override func viewDidLoad() {
        headerLabel.text = question
    }
}

extension QuestionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueCell(in: tableView)
        cell.textLabel?.text = self.options[indexPath.row]
        return cell
    }
    
    private func dequeueCell(in tableview: UITableView) -> UITableViewCell {
        if let cell = tableview.dequeueReusableCell(withIdentifier: reuseIdentifier) {
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    }
}

extension QuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selection?(selectedOptions(in: tableview))
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableview.allowsMultipleSelection {
            self.selection?(selectedOptions(in: tableview))
        }
    }
    
    private func selectedOptions(in tableView: UITableView) -> [String] {
        guard let indexpaths = tableView.indexPathsForSelectedRows else { return [] }
        
        return indexpaths.map { options[$0.row] }
    }
}
