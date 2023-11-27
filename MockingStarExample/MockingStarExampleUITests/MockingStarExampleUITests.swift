//
//  MockingStarExampleUITests.swift
//  MockingStarExampleUITests
//
//  Created by Yusuf Özgül on 27.11.2023.
//

import XCTest
import MockingStar

@MainActor
final class MockingStarExampleUITests: XCTestCase, BaseMockXCTest {
    let deviceId: String = UUID().uuidString
    let mockDomain: String = "Example"
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        app.launchEnvironment["MockingStarDomain"] = mockDomain
        app.launchEnvironment["MockingStar_DoNotUseLive"] = "1"
        app.launchEnvironment["DeviceID"] = deviceId
        app.launchEnvironment["EnableMockingStar"] = "1"
        app.launch()
    }

    func test_Search() async throws {
        try await setScenario(path: "/search/repositories",
                              method: .get,
                              scenario: "HappyPath")

        app.searchFields["Search"].tap()
        app.typeText("Trendyol")
        app.keyboards.buttons["Search"].tap()

        XCTAssertTrue(app.collectionViews.containing(.collectionView, identifier:"List").element.exists)
        XCTAssertTrue(app.staticTexts.containing(.staticText, identifier:"FullName").element.exists)
        XCTAssertTrue(app.staticTexts.containing(.staticText, identifier:"StarForkCount").element.exists)
        XCTAssertTrue(app.staticTexts.containing(.staticText, identifier:"Description").element.exists)
    }

    func test_Search_EmptyResult() async throws {
        try await setScenario(path: "/search/repositories",
                              method: .get,
                              scenario: "NoResult")

        app.searchFields["Search"].tap()
        app.typeText("MockingStar")
        app.keyboards.buttons["Search"].tap()

        XCTAssertTrue(app.staticTexts.containing(.staticText, identifier: "ContentUnavailableView").element.exists)
    }

    func test_Search_NetworkError() async throws {
        try await setScenario(path: "/search/repositories",
                              method: .get,
                              scenario: "NetworkError")

        app.searchFields["Search"].tap()
        app.typeText("MockingStar")
        app .keyboards.buttons["Search"].tap()

        XCTAssertTrue(app.alerts.element.exists)
    }

    func test_Search_TimeOut() async throws {
        try await setScenario(path: "/search/repositories",
                              method: .get,
                              scenario: "TimeOut")

        app.searchFields["Search"].tap()
        app.typeText("MockingStar")
        app.keyboards.buttons["Search"].tap()

        sleep(30) // wait until timeout

        XCTAssertTrue(app.alerts.element.exists)
    }
}
