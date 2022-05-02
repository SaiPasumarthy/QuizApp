//
//  UITableViewExtenstions.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 25/04/22.
//

import UIKit

extension UITableView {
    func register(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func dequeReusableCell<T>(_ type: T.Type) -> T? {
        let className = String(describing: type)
        let cell = dequeueReusableCell(withIdentifier: className) as? T
        return cell
    }
}
