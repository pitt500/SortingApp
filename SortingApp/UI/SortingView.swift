//
//  ContentView.swift
//  SortingApp
//
//  Created by Pedro Rojas on 08/03/25.
//

import SwiftUI
import Charts

struct SortingView: View {
    private static let initialState: [Int] = [27,8,12,54,32,42,32,54,97,14,96,9,28,35,5,41,78,11,14,96,1,18,73,91,79,65,28,80,98,99,11,19,65,78,61,31,64,41,98,10,69,99,4,62,60,11,85,26,64,25,2,77,97,52,90,76,50,72,73,46,100,16,29,52,63,5,61,71,47,89,15,36,28,83,67,46,71,10,94,77,88,71,44,71,77,13,32,54,67,73,92,42,21,35,39,22,29,58,42,15]
    
    @State private var sortingType: SortingType = .bubble
    @State private var isSorting = false
    @State private var sortingTask: Task<Void, Never>? = nil
    @State private var sortingAlgorithm = SortingAlgorithm(items: initialState)

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

            Text("Time: \(formattedTimeElapsed)")
                .font(.largeTitle)
                .padding()

            SortingChartView(items: sortingAlgorithm.items)
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
