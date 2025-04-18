//
//  ContentView.swift
//  SortingApp
//
//  Created by Pedro Rojas on 08/03/25.
//

import SwiftUI
import Charts
import Combine

struct SortingView: View {
    @State private var sortingType: SortingType = .bubble
    @State private var isSorting = false
    @State private var sortingTask: Task<Void, Never>? = nil
    @State private var sortingAlgorithm: SortingAlgorithm
    @State private var showSettings = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer = Timer.publish(every: 0.001, on: .main, in: .common)
    @State private var timerSubscription: Cancellable?
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
                        Text(algo.title)
                            .tag(algo)
                    }
                }
                .pickerStyle(.menu)
                #if os(macOS)
                .frame(maxWidth: 300, alignment: .center)
                #else
                .frame(maxWidth: .infinity, alignment: .center)
                #endif
                .padding(.vertical)

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
                    Text("Time: \(String(format: "%.3f s", elapsedTime))")
                        .font(.largeTitle)
                        .padding()
                        .monospacedDigit()
                    // ADD: Fixed frame width to prevent movement
                        .frame(width: 300, alignment: .center)
                }

                SortingChartView(
                    items: sortingAlgorithm.items,
                    firstIndex: sortingAlgorithm.firstIndex,
                    secondIndex: sortingAlgorithm.secondIndex
                )
                .padding()
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
                .frame(width: 350, height: 450)
        }
        #elseif os(visionOS)
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .frame(width: 450, height: 680)
        }
        #endif
        .onChange(of: settings.dataSetType) {
            reset()
        }
        .onDisappear {
            cancelTimer()
        }
        .onReceive(timer) { _ in
            elapsedTime += 0.001
        }
    }

    private func reset() {
        sortingAlgorithm.reset(with: currentDataSet)
        elapsedTime = 0
        cancelTimer()
    }

    private func startTimer() {
        elapsedTime = 0
        timer = Timer.publish(every: 0.001, on: .main, in: .common)
        timerSubscription = timer.connect()
    }

    private func cancelTimer() {
        timerSubscription?.cancel()
    }

    private func startSorting() {
        guard !isSorting else { return }
        isSorting = true
        startTimer()
        
        sortingTask = Task {
            await sortingAlgorithm.sort(using: sortingType)
            cancelTimer()
            isSorting = false
        }
    }

    private func cancelSorting() {
        sortingTask?.cancel()
        sortingTask = nil
        isSorting = false
        cancelTimer()
    }
}

// MARK: - Preview

struct SortingView_Previews: PreviewProvider {
    static var previews: some View {
        SortingView()
    }
}
