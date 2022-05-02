//
//  QuestionViewControllerTest.swift
//  QuizAppTests
//
//  Created by Sai Pasumarthy on 21/04/22.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_rendersQuestionHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_rendersOptions() {
        XCTAssertEqual(makeSUT().tableview.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableview.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableview.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_rendersOptionsText() {
        XCTAssertEqual(makeSUT(options: ["A1","A2"]).tableview.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1","A2"]).tableview.title(at: 1), "A2")
    }
    
    func test_viewDidLoad_withSingleSelection_configuresTableView() {
        XCTAssertFalse(makeSUT(options: ["A1","A2"], allowsMultipleSelection: false).tableview.allowsMultipleSelection)
    }
    
    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastChange() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { receivedAnswer = $0 }
        
        sut.tableview.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableview.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    func test_optionDeSelected_withSingleSelection_doesNotNotifiesDelegateWithAnEmptySelection() {
        var callbackCount = 0
        
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: false) { _ in callbackCount += 1 }
        
        sut.tableview.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableview.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_viewDidLoad_withMultipleSelection_configuresTableView() {
        XCTAssertTrue(makeSUT(options: ["A1","A2"], allowsMultipleSelection: true).tableview.allowsMultipleSelection)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateSelection() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) { receivedAnswer = $0 }
        
        sut.tableview.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableview.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A1", "A2"])
    }
    
    func test_optionDeSelected_withMultipleSelectionEnabled_notifiesDelegate() {
        var receivedAnswer = [String]()
        let sut = makeSUT(options: ["A1", "A2"], allowsMultipleSelection: true) { receivedAnswer = $0 }
        
        sut.tableview.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableview.deselect(row: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    // MARK: Helpers
    
    func makeSUT(question: String = "", options:[String] = [], allowsMultipleSelection: Bool = false, selection: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options:options, allowsMultipleSelection: allowsMultipleSelection, selection: selection)
        _ = sut.view
        return sut
    }
}

