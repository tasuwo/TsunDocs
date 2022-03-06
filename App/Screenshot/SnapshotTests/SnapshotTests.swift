//
//  Copyright © 2022 Tasuku Tozawa. All rights reserved.
//

import XCTest

class SnapshotTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testForSnapshot() throws {
        let app = XCUIApplication()
        let device = XCUIDevice.shared

        if UIDevice.current.userInterfaceIdiom == .phone {
            app.tabBars.buttons.element(boundBy: 0).tap()
            snapshot("01_Mylist")

            app.tables.cells.element(boundBy: 0).press(forDuration: 1.1)
            app.collectionViews.cells.element(boundBy: 0).tap()
            snapshot("02_Info")
            app.navigationBars.buttons.element(boundBy: 0).tap()

            app.tables.cells.element(boundBy: 0).press(forDuration: 1.1)
            app.collectionViews.cells.element(boundBy: 2).tap()
            snapshot("04_Emoji")
            app.windows.children(matching: .other).element(boundBy: 1).swipeDown(velocity: .fast)

            app.tabBars.buttons.element(boundBy: 1).tap()
            app.scrollViews.element.swipeDown()
            snapshot("03_Tags")
        } else {
            device.orientation = .landscapeRight

            app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
            snapshot("01_Mylist")

            app.tables.element(boundBy: 1).cells.element(boundBy: 0).press(forDuration: 1.1)
            app.collectionViews.cells.element(boundBy: 0).tap()
            snapshot("02_Info")
            app.navigationBars.buttons.element(boundBy: 1).tap()

            app.tables.element(boundBy: 1).cells.element(boundBy: 0).press(forDuration: 1.1)
            app.collectionViews.cells.element(boundBy: 2).tap()
            snapshot("04_Emoji")
            app.windows.children(matching: .other).element(boundBy: 1).swipeDown(velocity: .fast)

            app.tables.element(boundBy: 0).cells.element(boundBy: 1).tap()
            app.scrollViews.element.swipeDown()
            snapshot("03_Tags")
        }
    }
}
