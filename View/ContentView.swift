//
//  ContentView.swift
//  Habood
//
//  Created by Stephan Karatselios on 28/8/2025.
//

import SwiftUI

struct ContentView: View {
    
    let user: AppUser
    let onSignOut: () -> Void
    
    init(user: AppUser, onSignOut: @escaping () -> Void) {
        self.user = user
        self.onSignOut = onSignOut
    }
    
    @Environment(\.modelContext) private var context
    @State var isPresentingHabit = false
    @State var isPresentingMood = false
    @State var isPresentingSettings = false
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Habood")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(100)
            }
            VStack(alignment: .center, spacing: 50) {
                Button("Habit Tracker") {
                    isPresentingHabit = true
                }.fontWeight(.heavy)
                    .buttonStyle(ShadowButtonStyle())
                NavigationLink(destination: HabitTrackerView(), isActive: $isPresentingHabit) { EmptyView() }
            }
            VStack(alignment: .center, spacing: 50) {
                Button("Mood Tracker") {
                    isPresentingMood = true
                }.fontWeight(.heavy)
                    .buttonStyle(ShadowButtonStyle())
                NavigationLink(destination: MoodTrackerView(), isActive: $isPresentingMood) { EmptyView() }
            }
            VStack(alignment: .center, spacing: 50) {
                Button("Settings") {
                    isPresentingSettings = true
                }.fontWeight(.heavy)
                    .buttonStyle(ShadowButtonStyle())
                NavigationLink(destination: SettingsView(), isActive: $isPresentingSettings) { EmptyView() }
            }
        }.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Sign Out", action: onSignOut)
            }
        }
    }
}

