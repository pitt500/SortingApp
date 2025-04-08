import XCTest
@testable import SortingApp

final class SortingTypeTests: XCTestCase {
    func testAllCasesHaveUniqueIds() {
        let ids = SortingType.allCases.map { $0.id }
        let uniqueIds = Set(ids)
        XCTAssertEqual(ids.count, uniqueIds.count, "All sorting types should have unique IDs")
    }
    
    func testIdMatchesRawValue() {
        for type in SortingType.allCases {
            XCTAssertEqual(type.id, type.rawValue)
        }
    }
}