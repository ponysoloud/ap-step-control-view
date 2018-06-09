//
//  APStepControlViewLayoutTests.swift
//  APStepControlViewLayoutTests
//
//  Created by Александр Пономарев on 07.06.2018.
//  Copyright © 2018 Base team. All rights reserved.
//

import XCTest
@testable import APStepControlView

class APStepControlViewLayoutTests: XCTestCase {

    var viewUnderTest: APStepControlView!
    var viewController: UIViewController!

    override func setUp() {
        super.setUp()

        viewController = UIViewController(nibName: nil, bundle: nil)
        XCTAssertNotNil(viewController.view)

        viewUnderTest = APStepControlView(stepsCount: 0)
        viewController.view.addSubview(viewUnderTest)
    }

    override func tearDown() {
        viewUnderTest = nil
        viewController = nil

        super.tearDown()
    }

    func setConstraintsPositionHeightToViewUnderTest() {
        viewUnderTest.translatesAutoresizingMaskIntoConstraints = false
        viewUnderTest.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 250.0).isActive = true
        viewUnderTest.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        viewUnderTest.leftAnchor.constraint(equalTo: viewController.view.leftAnchor, constant: 70.0).isActive = true

        viewController.view.layoutIfNeeded()
    }

    func setConstraintsPositionHeightWidthToViewUnderTest() {
        viewUnderTest.translatesAutoresizingMaskIntoConstraints = false
        viewUnderTest.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 250.0).isActive = true
        viewUnderTest.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        viewUnderTest.leftAnchor.constraint(equalTo: viewController.view.leftAnchor, constant: 70.0).isActive = true
        viewUnderTest.widthAnchor.constraint(equalToConstant: 120.0).isActive = true

        viewController.view.layoutIfNeeded()
    }

    func testViewExplicitResizing() {
        // given
        XCTAssertEqual(viewUnderTest.bounds, CGRect.zero, "View's bounds has wrong not zero value")

        // when
        viewUnderTest.bounds.size.height = 64.0
        viewUnderTest.bounds.size.width = 20.0

        // then
        XCTAssertEqual(viewUnderTest.bounds.height, 64.0, "View's height not equal to the explicitly setted value")
        XCTAssertEqual(viewUnderTest.bounds.width, 20.0, "View's height not equal to the explicitly setted value")
    }

    func testViewResizingAfterPushing() {
        // given
        XCTAssertEqual(viewUnderTest.bounds, CGRect.zero, "View's height has wrong not zero value")
        viewUnderTest.bounds.size.height = 64.0
        viewUnderTest.bounds.size.width = 20.0

        // when
        viewUnderTest.push()

        // then
        XCTAssertEqual(viewUnderTest.bounds.height, 64.0, "View's height not equal to the explicitly setted value")
        XCTAssertEqual(viewUnderTest.bounds.width, 20.0, "View's height not equal to the explicitly setted value")
    }

    func testViewSettingPositionHeightConstraints() {
        // given
        XCTAssertEqual(viewUnderTest.bounds, CGRect.zero, "View's height has wrong not zero value")

        // when
        setConstraintsPositionHeightToViewUnderTest()

        // then
        XCTAssertEqual(viewUnderTest.bounds.height, 64.0, "View's height is wrong after setting constraints")
        XCTAssertEqual(viewUnderTest.frame.origin, CGPoint(x: 70.0, y: 250.0), "View's position is wrong after setting constraints")
    }

    func testViewSettingPositionHeightWidthConstraints() {
        // given
        XCTAssertEqual(viewUnderTest.bounds, CGRect.zero, "View's height has wrong not zero value")

        // when
        setConstraintsPositionHeightWidthToViewUnderTest()

        // then
        XCTAssertEqual(viewUnderTest.bounds.height, 64.0, "View's height is wrong after setting constraints")
        XCTAssertEqual(viewUnderTest.frame.origin, CGPoint(x: 70.0, y: 250.0), "View's position is wrong after setting constraints")
        XCTAssertEqual(viewUnderTest.bounds.width, 120.0, "View's width is wrong after setting constraints")
    }

    func testConstrainedPositionHeightViewLayoutAfterPushingInEmpty() {
        // given
        setConstraintsPositionHeightToViewUnderTest()

        // when
        viewUnderTest.push()
        viewController.view.layoutIfNeeded()

        // then
        XCTAssertEqual(viewUnderTest.bounds.height, 64.0, "View's height is wrong after pushing 1 step in empty view 0 -> 1")
        XCTAssertEqual(viewUnderTest.frame.origin, CGPoint(x: 70.0, y: 250.0), "View's position is wrong after pushing 1 step in empty view 0 -> 1")
        XCTAssertEqual(viewUnderTest.bounds.width, viewUnderTest.bounds.height, "View's size is wrong after pushing 1 step in empty view 0 -> 1")
    }

    func testConstrainedPositionHeightWidthViewLayoutAfterPushingInEmpty() {
        // given
        setConstraintsPositionHeightWidthToViewUnderTest()

        // when
        viewUnderTest.push()
        viewController.view.layoutIfNeeded()

        // then
        XCTAssertEqual(viewUnderTest.bounds.height, 64.0, "View's height is wrong after pushing 1 step in empty view 0 -> 1")
        XCTAssertEqual(viewUnderTest.frame.origin, CGPoint(x: 70.0, y: 250.0), "View's position is wrong after pushing 1 step in empty view 0 -> 1")
        XCTAssertEqual(viewUnderTest.bounds.width, 120.0, "View's width is wrong after pushing 1 step in empty view 0 -> 1")
    }

    func testConstrainedPositionHeightViewLayoutAfterPoping() {
        // given
        setConstraintsPositionHeightToViewUnderTest()

        viewUnderTest.push()
        viewController.view.layoutIfNeeded()

        let promise = expectation(description: "Step wasn't popped after deadline")
        let delay = 1.0

        // when
        self.viewUnderTest.pop()
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            promise.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        viewController.view.layoutIfNeeded()

        // then
        XCTAssertEqual(viewUnderTest.bounds.height, 64.0, "View's height is wrong after poping 1 step from non empty 1 -> 0")
        XCTAssertEqual(viewUnderTest.frame.origin, CGPoint(x: 70.0, y: 250.0), "View's position is wrong after poping 1 step from non empty 1 -> 0")
        XCTAssertEqual(viewUnderTest.bounds.width, 0.0, "View's width is wrong after poping 1 step from non empty 1 -> 0")
    }

    func testConstrainedPositionHeightWidthViewLayoutAfterPoping() {
        // given
        setConstraintsPositionHeightWidthToViewUnderTest()

        viewUnderTest.push()
        viewController.view.layoutIfNeeded()

        // when
        viewUnderTest.pop()
        viewController.view.layoutIfNeeded()

        // then
        XCTAssertEqual(viewUnderTest.bounds.height, 64.0, "View's height is wrong after poping 1 step from non empty 1 -> 0")
        XCTAssertEqual(viewUnderTest.frame.origin, CGPoint(x: 70.0, y: 250.0), "View's position is wrong after poping 1 step from non empty 1 -> 0")
        XCTAssertEqual(viewUnderTest.bounds.width, 120.0, "View's width is wrong after poping 1 step from non empty 1 -> 0")
    }
}

