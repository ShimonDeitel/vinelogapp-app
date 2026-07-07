import XCTest
@testable import Vinelog

@MainActor
final class VinelogTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testAddEntry() {
        let entry = CropEntry(name: "Test", variety: "A", bed: "B", plantedDate: "")
        store.add(entry)
        XCTAssertEqual(store.entries.count, 1)
    }

    func testDeleteEntry() {
        let entry = CropEntry(name: "Test", variety: "A", bed: "B", plantedDate: "")
        store.add(entry)
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntry() {
        var entry = CropEntry(name: "Test", variety: "A", bed: "B", plantedDate: "")
        store.add(entry)
        entry.name = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first?.name, "Updated")
    }

    func testFreeLimitEnforced() {
        for i in 0..<Store.freeLimit {
            store.add(CropEntry(name: "Item \(i)", variety: "", bed: "", plantedDate: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
        store.add(CropEntry(name: "Overflow", variety: "", bed: "", plantedDate: ""))
        XCTAssertEqual(store.entries.count, Store.freeLimit)
    }

    func testProUnlocksUnlimited() {
        store.isPro = true
        for i in 0..<(Store.freeLimit + 5) {
            store.add(CropEntry(name: "Item \(i)", variety: "", bed: "", plantedDate: ""))
        }
        XCTAssertEqual(store.entries.count, Store.freeLimit + 5)
    }

    func testSeedDataBelowFreeLimit() {
        let fresh = Store()
        XCTAssertLessThan(fresh.entries.count, Store.freeLimit)
    }

    func testDeleteAtOffsets() {
        store.add(CropEntry(name: "A", variety: "", bed: "", plantedDate: ""))
        store.add(CropEntry(name: "B", variety: "", bed: "", plantedDate: ""))
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.name, "B")
    }

    func testCanAddMoreInitiallyTrue() {
        XCTAssertTrue(store.canAddMore)
    }
}
