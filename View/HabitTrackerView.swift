//
//  HabitTracker.swift
//  Habood
//
//  Created by Stephan Karatselios on 28/8/2025.
//

import SwiftUI

struct HabitTrackerView: View {
    @State private var habit = Habit()
    @State private var hasHabit = false
    @State private var isPresentingSetHabit = false
    @StateObject private var store = LoadFile()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Habit Tracker")
                    .font(.largeTitle).fontWeight(.bold)
                    .padding(100)
            }
            VStack(alignment: .center) {
                if hasHabit, !habit.name.isEmpty {
                    Text(habit.name)
                    Text(habit.frequency)
                }
            }
            VStack {
                Button("Set Habit") { isPresentingSetHabit = true
                }
                .fontWeight(.heavy)
                .buttonStyle(ShadowButtonStyle())
            }
            NavigationLink(isActive: $isPresentingSetHabit) {
                SetHabitView(hasHabit: $hasHabit)
            } label: { EmptyView() }
        }
    }
}

