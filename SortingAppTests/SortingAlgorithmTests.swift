import XCTest
@testable import SortingApp

final class SortingAlgorithmTests: XCTestCase {
    var sut: SortingAlgorithm!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Helper Methods
    
    private func verifySorting(for array: [Int], file: StaticString = #file, line: UInt = #line) async {
        // Given
        sut = SortingAlgorithm(items: array)
        let expectedResult = array.sorted()
        
        // Test all sorting algorithms
        for sortType in SortingType.allCases {
            // When
            await sut.sort(using: sortType)
            
            // Then
            XCTAssertEqual(sut.items, expectedResult, "Failed sorting with \(sortType)", file: file, line: line)
        }
    }
    
    // MARK: - Tests
    
    func testEmptyArray() async {
        await verifySorting(for: [])
    }
    
    func testSingleElement() async {
        await verifySorting(for: [1])
    }
    
    func testAlreadySortedArray() async {
        await verifySorting(for: [1, 2, 3, 4, 5])
    }
    
    func testReverseSortedArray() async {
        await verifySorting(for: [5, 4, 3, 2, 1])
    }
    
    func testArrayWithDuplicates() async {
        await verifySorting(for: [3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5])
    }
    
    func testRandomArray() async {
        await verifySorting(for: [27, 8, 12, 54, 32, 42, 32, 34, 27, 14])
    }
    
    func testLargeArray() async {
        await verifySorting(for: DemoData.default)
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        // Given
        let initialArray = [3, 2, 1]
        sut = SortingAlgorithm(items: initialArray)
        
        // When
        sut.reset(with: [5, 4, 3])
        
        // Then
        XCTAssertEqual(sut.items, [5, 4, 3])
        XCTAssertNil(sut.timeElapsed)
        XCTAssertNil(sut.startTime)
        XCTAssertNil(sut.firstIndex)
        XCTAssertNil(sut.secondIndex)
    }
    
    // MARK: - Cancellation Tests
    
    func testSortingCancellation() async {
        // Given
        let array = [5, 4, 3, 2, 1]
        sut = SortingAlgorithm(items: array)
        
        // When
        let task = Task {
            await sut.sort(using: .bubble)
        }
        task.cancel()
        await task.value
        
        // Then
        // The array might be partially sorted, but shouldn't be fully sorted
        XCTAssertNotEqual(sut.items, array.sorted())
    }
    
    // MARK: - Time Elapsed Tests
    
    func testTimeElapsedTracking() async {
        // Given
        sut = SortingAlgorithm(items: [3, 2, 1])
        
        // When
        await sut.sort(using: .bubble)
        
        // Then
        XCTAssertNotNil(sut.timeElapsed)
        XCTAssertGreaterThan(sut.timeElapsed ?? 0, 0)
    }
}