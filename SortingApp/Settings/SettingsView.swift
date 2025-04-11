//
//  SettingsView.swift
//  SortingApp
//
//  Created by Pedro Rojas on 08/04/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.sortingSettings) private var settings
    @State private var showAbout = false
    
    var body: some View {
        #if os(macOS)
        NavigationStack {
            SettingsContent(
                settings: settings,
                showAbout: $showAbout
            )
                .frame(width: 350, height: 300)
                .padding()
                .sheet(isPresented: $showAbout) {
                    AboutView()
                        .frame(width: 300, height: 400)
                }
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
        }
        #else
        NavigationStack {
            settingsContent
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                .sheet(isPresented: $showAbout) {
                    AboutView()
                }
        }
        #endif
    }
}

struct SettingsContent: View {
    @Bindable var settings: SortingSettings
    @Binding var showAbout: Bool
    
    var body: some View {
        Form {
            Section("Animation") {
                Toggle("Enabled", isOn: $settings.animationsEnabled)
                
                if settings.animationsEnabled {
                    HStack {
                        Text("Duration")
                        Slider(
                            value: $settings.animationDuration,
                            in: 0.01...1.0,
                            step: 0.01
                        )
                        Text(String(format: "%.2f", settings.animationDuration))
                    }
                }
            }
            
            Section("Display") {
                Toggle("Show Timer", isOn: $settings.showTimer)
                Toggle("Show Bar Values", isOn: $settings.showBarValues)
            }
            
            Section("Data Set") {
                Picker("Type", selection: $settings.dataSetType) {
                    ForEach(DataSetType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    Button("About Sorting Visualizer") {
                        showAbout.toggle()
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }
        }
        #if os(macOS)
        .formStyle(.grouped)
        #endif
    }
}

#Preview {
    SettingsView()
}
