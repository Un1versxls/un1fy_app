//
//  Niche.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import Foundation

struct Niche: Codable, Identifiable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let iconSystemName: String
    let isPremium: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        description: String,
        iconSystemName: String,
        isPremium: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconSystemName = iconSystemName
        self.isPremium = isPremium
    }
    
    static let `default` = Niche(
        name: "General",
        description: "General productivity and habit building",
        iconSystemName: "star.fill"
    )
    
    static let sampleList: [Niche] = [
        Niche(name: "Fitness", description: "Build consistent workout habits", iconSystemName: "dumbbell.fill"),
        Niche(name: "Meditation", description: "Master daily mindfulness practice", iconSystemName: "brain.head.profile"),
        Niche(name: "Reading", description: "Develop daily reading routines", iconSystemName: "book.fill"),
        Niche(name: "Coding", description: "Learn and practice coding daily", iconSystemName: "chevron.left.forwardslash.chevron.right"),
        Niche(name: "Writing", description: "Write consistently every day", iconSystemName: "pencil.and.outline", isPremium: true),
        Niche(name: "Nutrition", description: "Improve your eating habits", iconSystemName: "leaf.fill", isPremium: true)
    ]
}
