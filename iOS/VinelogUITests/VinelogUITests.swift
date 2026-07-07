import XCTest

final class VinelogUITests: XCTestCase {
    var app: XCUIApplication!
    static let freeLimitForUITest = 10

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testAddEntryFlow() {
        app.buttons["addEntryButton"].tap()
        let nameField = app.textFields["entryNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText("UI Test Entry")
        app.buttons["entrySaveButton"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Entry"].waitForExistence(timeout: 2))
    }

    func testKeyboardDismissOnTapOutside() {
        app.buttons["addEntryButton"].tap()
        let nameField = app.textFields["entryNameField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText("Dismiss Test")
        XCTAssertTrue(app.keyboards.element.exists)
        app.navigationBars.element.tap()
        XCTAssertFalse(app.keyboards.element.exists)
        app.buttons["entryCancelButton"].tap()
    }

    func testFreeLimitTriggersPaywall() {
        for i in 0..<(Self.freeLimitForUITest + 1) {
            app.buttons["addEntryButton"].tap()
            let nameField = app.textFields["entryNameField"]
            if nameField.waitForExistence(timeout: 2) {
                nameField.tap()
                nameField.typeText("Item \(i)")
                app.buttons["entrySaveButton"].tap()
            } else if app.staticTexts["Vinelog Pro"].waitForExistence(timeout: 2) {
                break
            }
        }
        XCTAssertTrue(app.staticTexts["Vinelog Pro"].waitForExistence(timeout: 3))
    }

    func testSettingsOpens() {
        app.buttons["settingsButton"].tap()
        XCTAssertTrue(app.buttons["settingsDoneButton"].waitForExistence(timeout: 2))
        app.buttons["settingsDoneButton"].tap()
    }
}
