//
//  AppPlan.swift
//  DRIVE
//
//  Created by Kilo on 07/04/2026.
//

import Foundation

enum PlanType: String, Codable {
    case free, basic, pro, lifetime
}

struct AppPlan: Codable, Identifiable, Equatable {
    let id: UUID
    let type: PlanType
    let name: String
    let price: Double
    let durationDays: Int?
    let features: [String]
    let isActive: Bool
    let expirationDate: Date?
    
    init(
        id: UUID = UUID(),
        type: PlanType,
        name: String,
        price: Double,
        durationDays: Int? = nil,
        features: [String],
        isActive: Bool = false,
        expirationDate: Date? = nil
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.price = price
        self.durationDays = durationDays
        self.features = features
        self.isActive = isActive
        self.expirationDate = expirationDate
    }
    
    static let free = AppPlan(
        type: .free,
        name: "Free",
        price: 0.0,
        features: [
            "2 Habit tracks",
            "Basic analytics",
            "Community access"
        ],
        isActive: true
    )
    
    static let pro = AppPlan(
        type: .pro,
        name: "Pro",
        price: 9.99,
        durationDays: 30,
        features: [
            "Unlimited habit tracks",
            "Advanced analytics",
            "Priority support",
            "Premium niches",
            "Custom reminders",
            "Export data"
        ]
    )
}
