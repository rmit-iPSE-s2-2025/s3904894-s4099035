//
//  HabitList.swift
//  Habood
//
//  Created by Stephan Karatselios on 29/8/2025.
//

import Foundation

struct HabitList: Identifiable, Codable {
    let id: Int
    let habitName: String
    let habitFrequency: String
}
