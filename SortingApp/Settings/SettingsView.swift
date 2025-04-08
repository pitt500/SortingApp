//
//  SettingsView.swift
//  SortingApp
//
//  Created by Pedro Rojas on 08/04/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings = SortingSettings.shared
    @State private var showAbout = false
    
    var body: some View {
        #if os(macOS)
        settingsContent
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
    
    private var settingsContent: some View {
        Form {
            Section {
                Toggle("Enable Animations", isOn: $settings.animationsEnabled)
                Toggle("Show Bar Values", isOn: $settings.showBarValues)
                Toggle("Show Timer", isOn: $settings.showTimer)
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Animation Speed")
                    HStack {
                        Text("Faster")
                        Slider(
                            value: $settings.animationDuration,
                            in: 0.1...2.0,
                            step: 0.1
                        )
                        Text("Slower")
                    }
                    Text("\(settings.animationDuration, specifier: "%.1f") seconds")
                        .foregroundStyle(.secondary)
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
