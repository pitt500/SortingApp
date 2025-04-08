//
//  SortingChartView.swift
//  SortingApp
//
//  Created by Pedro Rojas on 05/04/25.
//

import SwiftUI
import Charts

struct SortingChartView: View {
    let items: [Int]
    let firstIndex: Int?
    let secondIndex: Int?
    
    private var settings: SortingSettings {
        SortingSettings.shared
    }

    var body: some View {
        GeometryReader { proxy in
            Chart {
                ForEach(Array(items.enumerated()), id: \.offset) { (index, value) in
                    BarMark(
                        x: .value("Index", index),
                        y: .value("Value", value),
                        width: .fixed(proxy.size.width / CGFloat(items.count))
                    )
                    .foregroundStyle(barColor(index: index, value: value))
                    .annotation(position: .top) {
                        if settings.showBarValues {
                            Text("\(value)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .animation(settings.animationsEnabled ? .linear(duration: settings.animationDuration) : nil, value: items)
            .padding()
        }
    }

    private func barColor(index: Int, value: Int) -> Color {
        if index == firstIndex {
            return .black
        } else if index == secondIndex {
            return .gray
        }
        
        let normalized = Double(value - 1) / 99.0
        let hue = 0.4 * normalized
        return Color(hue: hue, saturation: 0.9, brightness: 0.9)
    }
}

#Preview {
    SortingChartView(
        items: [15, 3, 14, 29, 10, 8, 21, 13, 5, 20],
        firstIndex: 2,
        secondIndex: 5
    )
}
