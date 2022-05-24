//
//  MultipleSelectionStore.swift
//  QuizApp
//
//  Created by Sai Pasumarthy on 24/05/22.
//

import Foundation

struct MultipleSelectionStore {
    private let handler: ([String]) -> Void
    var options: [MultipleSelectionOption]
    
    var canSubmit: Bool {
        !options.filter(\.isSelected).isEmpty
    }
    
    internal init(options: [String], handler: @escaping ([String]) -> Void = { _ in }) {
        self.options = options.map { MultipleSelectionOption(text: $0)}
        self.handler = handler
    }
    
    func submit() {
        guard canSubmit else { return }
        handler(options.filter(\.isSelected).map(\.text))
    }
}

struct MultipleSelectionOption {
    let text: String
    var isSelected: Bool = false
    
    mutating func select() {
        isSelected.toggle()
    }
}
