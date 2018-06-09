//
//  APStepControlViewPropertiesTests.swift
//  APStepControlViewPropertiesTests
//
//  Created by Александр Пономарев on 06.06.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import XCTest
@testable import APStepControlView

class APStepControlViewPropertiesTests: XCTestCase {
    
    var viewUnderTest: APStepControlView!

    override func setUp() {
        super.setUp()

        viewUnderTest = APStepControlView(stepsCount: 5)
    }

    override func tearDown() {
        viewUnderTest = nil

        super.tearDown()
    }

    func testViewStepsCountAfterInitWithCount() {
        // then
        XCTAssertEqual(viewUnderTest.stepsCount, 5, "Wrong number of steps after initializing")
    }

    func testViewStepsCountAfterPush() {
        // given
        let count = viewUnderTest.stepsCount

        // when
        viewUnderTest.push()

        // then
        XCTAssertEqual(viewUnderTest.stepsCount, count + 1, "Wrong number of steps after pushing")
    }

    func testViewStepsCountAfterPop() {
        // given
        let count = viewUnderTest.stepsCount

        // when
        viewUnderTest.pop()

        // then
        XCTAssertEqual(viewUnderTest.stepsCount, count - 1, "Wrong number of steps after poping")
    }
}
