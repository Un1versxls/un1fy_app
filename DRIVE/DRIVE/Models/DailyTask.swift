//
//  DailyTask.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import Foundation

struct DailyTask: Codable, Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String?
    let targetDate: Date
    var completedDate: Date?
    var xpReward: Int
    let niche: Niche?
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String? = nil,
        targetDate: Date,
        completedDate: Date? = nil,
        xpReward: Int = 10,
        niche: Niche? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.targetDate = targetDate
        self.completedDate = completedDate
        self.xpReward = xpReward
        self.niche = niche
    }
    
    var isCompleted: Bool { completedDate != nil }
    
    mutating func markCompleted() {
        completedDate = Date()
    }
    
    mutating func markIncomplete() {
        completedDate = nil
    }
    
    static func generateForDate(_ date: Date, count: Int = 3) -> [DailyTask] {
        let titles = [
            "Complete morning routine",
            "20 minutes focused practice",
            "Review daily progress",
            "Mindfulness exercise",
            "Daily learning session"
        ]
        
        return (0..<min(count, titles.count)).map { index in
            DailyTask(
                title: titles[index],
                targetDate: date,
                xpReward: 15 + (index * 5)
            )
        }
    }
}
