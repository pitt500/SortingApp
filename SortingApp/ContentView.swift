//
//  ContentView.swift
//  SortingApp
//
//  Created by Pedro Rojas on 08/03/25.
//

import SwiftUI
import AVFoundation
import Charts

struct SortingView: View {
    
    @State private var items: [Int] =
    [27,8,12,54,32,42,32,54,97,14,96,9,28,35,5,41,78,11,14,96,1,18,73,91,79,65,28,80,98,99,11,19,65,78,61,31,64,41,98,10,69,99,4,62,60,11,85,26,64,25,2,77,97,52,90,76,50,72,73,46,100,16,29,52,63,5,61,71,47,89,15,36,28,83,67,46,71,10,94,77,88,71,44,71,77,13,32,54,67,73,92,42,21,35,39,22,29,58,42,15]
    @State private var selectedAlgorithm: SortingAlgorithm = .bubble
    @State private var isSorting = false
    
    // We'll store the current sort task (if any).
    @State private var sortingTask: Task<Void, Never>? = nil
    
    // We'll also track how long the sort took.
    @State private var startTime: Date? = nil
    @State private var timeElapsed: TimeInterval? = nil

    var body: some View {
        VStack {
            Picker("Algorithm", selection: $selectedAlgorithm) {
                ForEach(SortingAlgorithm.allCases, id: \.self) { algo in
                    Text(algo.rawValue).tag(algo)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            HStack {
                Spacer()
                Button {
                    startSorting()
                } label: {
                    Text("Sort")
                        .padding()
                }
                .disabled(isSorting)
                
                Spacer(minLength: 20)
                
                Button {
                    reset()
                } label: {
                    Text("Reset")
                        .padding()
                }
                Spacer()
                
                Button {
                    cancelSorting()
                } label: {
                    Text("Cancel")
                        .padding()
                }
                .disabled(!isSorting)
                Spacer()
            }

            // Visualization of the array
//            HStack(alignment: .bottom, spacing: 4) {
//                ForEach(items.indices, id: \.self) { index in
//                    Rectangle()
//                        .frame(width: 12, height: CGFloat(items[index]) * 2)
//                        .overlay(
//                            Text("\(items[index])")
//                                .font(.caption2)
//                                .rotationEffect(.degrees(-90))
//                                .offset(y: -10)
//                        )
//                }
//            }
//            .animation(.default, value: items)
//            .padding()
            
            // Show time taken
            Text("Time: \(formattedTimeElapsed)")
                .font(.largeTitle)
                .padding()

            
            Chart {
                // We iterate over items with indices to create a bar for each
                ForEach(Array(items.enumerated()), id: \.offset) { (index, value) in
                    BarMark(
                        x: .value("Index", index),
                        y: .value("Value", value)
                    )
                    .foregroundStyle(barColor(value: value))
                    // Optional: Show the value on top of each bar
//                    .annotation(position: .top) {
//                        Text("\(value)")
//                            .font(.caption2)
//                    }
                }
            }
            // Hide axes if you just want the visual bars
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
            // Animate changes any time `items` is modified
            //.animation(.default, value: items)
            .animation(.linear(duration: 0.2), value: items)
            
            .frame(height: 250) // Adjust as desired
            .padding()
        }
    }
    
    /// Returns a Color whose hue is based on the given integer.
    /// Adjust these constants to create a desired color range.
    private func barColor(value: Int) -> Color {
        // Suppose the valid range is [1..100]. Normalize 'value' into [0..1].
        let normalized = Double(value - 1) / 99.0
        
        // Map that to a hue range, e.g. [0..0.4] (red -> orange/green).
        // Increase that hue range for a bigger shift (e.g. 0..1 for full rainbow).
        let hue = 0.4 * normalized
        
        // Create the color with a certain saturation & brightness
        return Color(hue: hue, saturation: 0.9, brightness: 0.9)
    }
    
    private func reset() {
        //items.shuffle()
        
        items = [27,8,12,54,32,42,32,54,97,14,96,9,28,35,5,41,78,11,14,96,1,18,73,91,79,65,28,80,98,99,11,19,65,78,61,31,64,41,98,10,69,99,4,62,60,11,85,26,64,25,2,77,97,52,90,76,50,72,73,46,100,16,29,52,63,5,61,71,47,89,15,36,28,83,67,46,71,10,94,77,88,71,44,71,77,13,32,54,67,73,92,42,21,35,39,22,29,58,42,15]
    }

    // MARK: - Main sort dispatcher

    private func startSorting() {
        guard !isSorting else { return }
        // Reset time
        startTime = Date()
        timeElapsed = nil
        
        isSorting = true
        
        // Keep track of start time
        let startTime = Date()
        
        // Create a new Task for sorting
        sortingTask = Task {
            switch selectedAlgorithm {
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
            
            // If the task wasn't canceled, compute the total time
            if !Task.isCancelled {
                let endTime = Date()
                timeElapsed = endTime.timeIntervalSince(startTime)
            }
            
            // Once sorting finishes (or is canceled):
            isSorting = false
            sortingTask = nil
        }
    }
    
    private func cancelSorting() {
        // Cancel the current sort task
        sortingTask?.cancel()
        sortingTask = nil
        isSorting = false
    }

    // MARK: - 1) Bubble Sort
    
    private func bubbleSort() async {
        for i in 0..<items.count {
            for j in 0..<items.count - i - 1 {
                if Task.isCancelled { return }
                
                // Swap if needed
                if items[j] > items[j + 1] {
                    await MainActor.run {
                        items.swapAt(j, j + 1)
                    }
                }
                // Update time & pause to let UI refresh
                await updateTimeElapsed()
                await Task.yield()
            }
        }
    }
    
    // MARK: - 2) Selection Sort
    
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
                await MainActor.run {
                    items.swapAt(i, minIndex)
                }
            }
        }
    }
    
    // MARK: - 3) Insertion Sort
    
    private func insertionSort() async {
        for i in 1..<items.count {
            if Task.isCancelled { return }
            
            let key = items[i]
            var j = i - 1
            while j >= 0 && items[j] > key {
                if Task.isCancelled { return }
                
                await MainActor.run {
                    items[j + 1] = items[j]
                }
                j -= 1
                
                // Update time & pause to let UI refresh
                await updateTimeElapsed()
                await Task.yield()
            }
            await MainActor.run {
                items[j + 1] = key
            }
        }
    }
    
    // MARK: - 4) Merge Sort
    
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
                    await MainActor.run {
                        items[k] = leftArray[i]
                    }
                    i += 1
                } else {
                    await MainActor.run {
                        items[k] = rightArray[j]
                    }
                    j += 1
                }
            } else if i < leftArray.count {
                await MainActor.run {
                    items[k] = leftArray[i]
                }
                i += 1
            } else {
                await MainActor.run {
                    items[k] = rightArray[j]
                }
                j += 1
            }
            
            // Update time & pause to let UI refresh
            await updateTimeElapsed()
            await Task.yield()
        }
    }
    
    // MARK: - 5) Quick Sort
    
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
                await MainActor.run {
                    items.swapAt(i, j)
                }
                i += 1
            }
            
            // Update time & pause to let UI refresh
            await updateTimeElapsed()
            await Task.yield()
        }
        await MainActor.run {
            items.swapAt(i, high)
        }
        return i
    }
    
    // MARK: - Time Formatting
    private var formattedTimeElapsed: String {
        guard let timeElapsed else { return "N/A" }
        // Format to 3 decimal places, e.g. "0.123 s"
        return String(format: "%.3f s", timeElapsed)
    }
    
    /// Refresh the 'timeElapsed' to show how long the sort has been running.
    @MainActor
    private func updateTimeElapsed() async {
        guard let startTime = startTime else { return }
        
        self.timeElapsed = Date().timeIntervalSince(startTime)
    }
}

// MARK: - Picker Enum

enum SortingAlgorithm: String, CaseIterable {
    case bubble = "Bubble"
    case selection = "Selection"
    case insertion = "Insertion"
    case merge = "Merge"
    case quick = "Quick"
}

// MARK: - Preview

struct SortingView_Previews: PreviewProvider {
    static var previews: some View {
        SortingView()
    }
}
