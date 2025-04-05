//
//  SortingAlgorithm.swift
//  SortingApp
//
//  Created by Pedro Rojas on 05/04/25.
//

import SwiftUI

enum SortingType: String, CaseIterable, Identifiable {
    case bubble = "Bubble"
    case selection = "Selection"
    case insertion = "Insertion"
    case merge = "Merge"
    case quick = "Quick"
    
    var id: String {
        self.rawValue
    }
}

@Observable
class SortingAlgorithm {
    var items: [Int]
    var timeElapsed: TimeInterval? = nil
    var startTime: Date? = nil
    
    init(items: [Int]) {
        self.items = items
    }
    
    func sort(using sortingType: SortingType) async {
        startTime = Date()
        
        switch sortingType {
        case .bubble:
            await bubbleSort()
        case .selection:
            await selectionSort()
        case .insertion:
            await insertionSort()
        case .merge:
            await mergeSort(0, items.count - 1)
        case .quick:
            await quickSort(0, items.count - 1)
        }
    }
    
    func reset(with items: [Int]) {
        self.items = items
        timeElapsed = nil
        startTime = nil
    }

    private func bubbleSort() async {
        for i in 0..<items.count {
            for j in 0..<items.count - i - 1 {
                if Task.isCancelled { return }
                if items[j] > items[j + 1] {
                    items.swapAt(j, j + 1)
                }
                
                // Update time & pause to let UI refresh
                await updateTimeElapsed()
                await Task.yield()
            }
        }
    }

    private func selectionSort() async {
        for i in 0..<items.count {
            if Task.isCancelled { return }
            var minIndex = i
            for j in (i+1)..<items.count {
                if Task.isCancelled { return }
                if items[j] < items[minIndex] {
                    minIndex = j
                }
                
                // Update time & pause to let UI refresh
                await updateTimeElapsed()
                await Task.yield()
            }
            if minIndex != i {
                items.swapAt(i, minIndex)
            }
        }
    }

    private func insertionSort() async {
        for i in 1..<items.count {
            if Task.isCancelled { return }
            let key = items[i]
            var j = i - 1
            while j >= 0 && items[j] > key {
                if Task.isCancelled { return }
                items[j + 1] = items[j]
                j -= 1
                
                // Update time & pause to let UI refresh
                await updateTimeElapsed()
                await Task.yield()
            }
            items[j + 1] = key
        }
    }

    private func mergeSort(_ left: Int, _ right: Int) async {
        if left < right {
            if Task.isCancelled { return }
            let mid = (left + right) / 2
            await mergeSort(left, mid)
            if Task.isCancelled { return }
            await mergeSort(mid + 1, right)
            if Task.isCancelled { return }
            await merge(left, mid, right)
        }
    }

    private func merge(_ left: Int, _ mid: Int, _ right: Int) async {
        let leftArray = Array(items[left...mid])
        let rightArray = Array(items[mid+1...right])
        var i = 0
        var j = 0
        for k in left...right {
            if Task.isCancelled { return }
            if i < leftArray.count && j < rightArray.count {
                if leftArray[i] <= rightArray[j] {
                    items[k] = leftArray[i]
                    i += 1
                } else {
                    items[k] = rightArray[j]
                    j += 1
                }
            } else if i < leftArray.count {
                items[k] = leftArray[i]
                i += 1
            } else {
                items[k] = rightArray[j]
                j += 1
            }
            
            // Update time & pause to let UI refresh
            await updateTimeElapsed()
            await Task.yield()
        }
    }

    private func quickSort(_ low: Int, _ high: Int) async {
        if Task.isCancelled { return }
        if low < high {
            let pivotIndex = await partition(low, high)
            if Task.isCancelled { return }
            await quickSort(low, pivotIndex - 1)
            if Task.isCancelled { return }
            await quickSort(pivotIndex + 1, high)
        }
    }

    private func partition(_ low: Int, _ high: Int) async -> Int {
        let pivot = items[high]
        var i = low
        for j in low..<high {
            if Task.isCancelled { return i }
            if items[j] < pivot {
                items.swapAt(i, j)
                i += 1
            }
            
            // Update time & pause to let UI refresh
            await updateTimeElapsed()
            await Task.yield()
        }
        items.swapAt(i, high)
        return i
    }
    
    /// Refresh the 'timeElapsed' to show how long the sort has been running.
    @MainActor
    private func updateTimeElapsed() async {
        guard let startTime = startTime else { return }
        
        self.timeElapsed = Date().timeIntervalSince(startTime)
    }
}
