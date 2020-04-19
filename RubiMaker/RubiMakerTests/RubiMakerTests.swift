//
//  RubiMakerTests.swift
//  RubiMakerTests
//
//  Created by 石場清子 on 2020/04/12.
//  Copyright © 2020 石場清子. All rights reserved.
//

import XCTest
@testable import RubiMaker

class RubiMakerTests: XCTestCase {

    private var inputFromTextViewController: InputFromTextViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_convertButtonをタップしたら変換されたtextがconvertedTextViewに表示される() {
        inputFromTextViewController = InputFromTextViewController.instance(convertAPI: ConvertResponseStub.init(requestId: "labs.goo.ne.jp\t1587286212\t0", outputType: "hiragana", converted: "へんかんされたてきすと"))
        inputFromTextViewController.loadViewIfNeeded()
        inputFromTextViewController.buttonStyle = .convert
        inputFromTextViewController.didTapConvertButton(inputFromTextViewController.convertButton)
        inputFromTextViewController.loadViewIfNeeded()
        let actual = inputFromTextViewController.convertedTextView.text
        let expected = "へんかんされたてきすと"
        XCTAssertEqual(actual, expected)
    }
}
