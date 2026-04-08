//
//  UserProfile.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import Foundation

struct UserProfile: Codable, Equatable {
    let id: UUID
    var xp: Int
    var streakCount: Int
    var level: Int
    var selectedNiche: Niche?
    var dailyGoalMinutes: Int
    var joinDate: Date
    var lastActiveDate: Date?
    
    init(
        id: UUID = UUID(),
        xp: Int = 0,
        streakCount: Int = 0,
        level: Int = 1,
        selectedNiche: Niche? = nil,
        dailyGoalMinutes: Int = 30,
        joinDate: Date = Date(),
        lastActiveDate: Date? = nil
    ) {
        self.id = id
        self.xp = xp
        self.streakCount = streakCount
        self.level = level
        self.selectedNiche = selectedNiche
        self.dailyGoalMinutes = dailyGoalMinutes
        self.joinDate = joinDate
        self.lastActiveDate = lastActiveDate
    }
    
    var xpForNextLevel: Int { level * 1000 }
    var currentLevelProgress: Double { Double(xp) / Double(xpForNextLevel) }
    
    mutating func addXP(_ amount: Int) {
        xp += amount
        while xp >= xpForNextLevel {
            xp -= xpForNextLevel
            level += 1
        }
    }
    
    static let `default` = UserProfile()
}
