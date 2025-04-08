//
//  SortingSettings.swift
//  SortingApp
//
//  Created by Pedro Rojas on 08/04/25.
//


import SwiftUI

@Observable
class SortingSettings {
    var animationsEnabled = true
    var showBarValues = true
    var showTimer = true
    var animationDuration: Double = 0.5
    
    static let shared = SortingSettings()
    private init() {}
}