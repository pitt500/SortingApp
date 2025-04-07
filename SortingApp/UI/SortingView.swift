//
//  ContentView.swift
//  SortingApp
//
//  Created by Pedro Rojas on 08/03/25.
//

import SwiftUI
import Charts

struct SortingView: View {
    private static let initialState: [Int] = [27,8,12,54,32,42,32,34,27,14,36,9,28,35,5,41,78,11,14]
    
    @State private var sortingType: SortingType = .bubble
    @State private var isSorting = false
    @State private var sortingTask: Task<Void, Never>? = nil
    @State private var sortingAlgorithm = SortingAlgorithm(items: initialState)
    @State private var showTimer = false

    var body: some View {
        VStack {
            Picker("Algorithm", selection: $sortingType) {
                ForEach(SortingType.allCases) { algo in
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
                .disabled(isSorting)
                
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

            if showTimer {
                Text("Time: \(formattedTimeElapsed)")
                    .font(.largeTitle)
                    .padding()
            }

            SortingChartView(
                items: sortingAlgorithm.items,
                firstIndex: sortingAlgorithm.firstIndex,
                secondIndex: sortingAlgorithm.secondIndex
            )
                
        }
    }

    private func reset() {
        sortingAlgorithm.reset(with: Self.initialState)
    }

    private func startSorting() {
        guard !isSorting else { return }
        isSorting = true
        
        sortingTask = Task {
            await sortingAlgorithm.sort(using: sortingType)

            isSorting = false
        }
    }

    private func cancelSorting() {
        sortingTask?.cancel()
        sortingTask = nil
        isSorting = false
    }

    private var formattedTimeElapsed: String {
        guard let time = sortingAlgorithm.timeElapsed else { return "N/A" }
        return String(format: "%.3f s", time)
    }
}

// MARK: - Preview

struct SortingView_Previews: PreviewProvider {
    static var previews: some View {
        SortingView()
    }
}
