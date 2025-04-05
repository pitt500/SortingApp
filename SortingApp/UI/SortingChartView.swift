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

    var body: some View {
        Chart {
            ForEach(Array(items.enumerated()), id: \.offset) { (index, value) in
                BarMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                )
                .foregroundStyle(barColor(value))
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .animation(.linear(duration: 0.2), value: items)
    }

    private func barColor(_ value: Int) -> Color {
        let normalized = Double(value - 1) / 99.0
        let hue = 0.4 * normalized
        return Color(hue: hue, saturation: 0.9, brightness: 0.9)
    }
}