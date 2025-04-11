//
//  ContentView.swift
//  SortingApp
//
//  Created by Pedro Rojas on 08/03/25.
//

import SwiftUI
import Charts

struct SortingView: View {
    @State private var sortingType: SortingType = .bubble
    @State private var isSorting = false
    @State private var sortingTask: Task<Void, Never>? = nil
    @State private var sortingAlgorithm: SortingAlgorithm
    @State private var showSettings = false
    @Environment(\.sortingSettings) private var settings
    
    init() {
        _sortingAlgorithm = State(
            initialValue: SortingAlgorithm(
                items: DataSetType.small.generateData()
            )
        )
    }
    
    private var currentDataSet: [Int] {
        settings.dataSetType.generateData()
    }

    var body: some View {
        NavigationStack {
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

                if settings.showTimer {
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
            .navigationTitle("Sorting Visualizer")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                #elseif os(macOS) || os(visionOS)
                ToolbarItem {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                #endif
            }
        }
        #if os(iOS)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        #elseif os(macOS)
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .frame(width: 350, height: 300)
        }
        #elseif os(macOS) || os(visionOS)
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .frame(width: 450, height: 580)
        }
        #endif
        .onChange(of: settings.dataSetType) {
            reset()
        }
    }

    private func reset() {
        sortingAlgorithm.reset(with: currentDataSet)
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
