import SwiftUI

struct PlanCard: View {
    let plan: PlanItem
    let isSelected: Bool
    let onSelect: () -> Void
    
    @State private var isHovering = false
    @State private var isPressed = false
    @State private var checkmarkScale: CGFloat = 0
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: DriveSpacing.base) {
                headerSection
                
                if !plan.features.isEmpty {
                    Divider()
                        .background(Color.driveGlassBorder)
                    
                    featuresSection
                }
                
                if let price = plan.price {
                    Divider()
                        .background(Color.driveGlassBorder)
                    
                    priceSection(price: price)
                }
            }
            .padding(DriveSpacing.base)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassMorphism(
                backgroundOpacity: isSelected ? 0.06 : 0.03,
                borderOpacity: isSelected ? 0.3 : 0.1,
                cornerRadius: DriveRadius.xl
            )
            .overlay(
                RoundedRectangle(cornerRadius: DriveRadius.xl)
                    .strokeBorder(
                        isSelected ? .drivePrimary : LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom),
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: DriveRadius.xl)
                    .fill(.drivePrimary.opacity(0.05))
                    .opacity(isHovering && !isSelected ? 1 : 0)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(DriveAnimations.standard) {
                isHovering = hovering
            }
        }
        .onChange(of: isSelected) { _, selected in
            withAnimation(DriveAnimations.bouncy) {
                checkmarkScale = selected ? 1 : 0
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: DriveSpacing.xxs) {
                HStack(spacing: DriveSpacing.sm) {
                    Text(plan.name)
                        .font(.driveTitle3)
                        .fontWeight(.semibold)
                        .foregroundColor(.driveTextPrimary)
                    
                    if plan.isPopular {
                        Text("POPULAR")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, DriveSpacing.sm)
                            .padding(.vertical, DriveSpacing.xxs)
                            .background(
                                Capsule()
                                    .fill(.drivePrimary)
                            )
                    }
                }
                
                if let subtitle = plan.subtitle {
                    Text(subtitle)
                        .font(.driveSubheadline)
                        .foregroundColor(.driveTextSecondary)
                }
            }
            
            Spacer()
            
            selectionIndicator
        }
    }
    
    // MARK: - Selection Indicator
    
    private var selectionIndicator: some View {
        ZStack {
            Circle()
                .fill(isSelected ? .drivePrimary : Color.driveSurfaceElevated)
                .frame(width: 28, height: 28)
                .overlay(
                    Circle()
                        .strokeBorder(
                            isSelected ? Color.clear : Color.driveGlassBorder,
                            lineWidth: 2
                        )
                )
            
            Image(systemName: "checkmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .scaleEffect(checkmarkScale)
        }
    }
    
    // MARK: - Features Section
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: DriveSpacing.sm) {
            ForEach(plan.features, id: \.self) { feature in
                HStack(spacing: DriveSpacing.sm) {
                    Image(systemName: feature.included ? "checkmark.circle.fill" : "xmark.circle")
                        .font(.system(size: 14))
                        .foregroundColor(feature.included ? .driveSuccess : .driveTextTertiary)
                    
                    Text(feature.title)
                        .font(.driveSubheadline)
                        .foregroundColor(feature.included ? .driveTextPrimary : .driveTextTertiary)
                    
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Price Section
    
    private func priceSection(price: PlanPrice) -> some View {
        HStack(alignment: .lastTextBaseline, spacing: DriveSpacing.xxs) {
            if let prefix = price.prefix {
                Text(prefix)
                    .font(.driveTitle3)
                    .fontWeight(.semibold)
                    .foregroundColor(.driveTextSecondary)
            }
            
            Text(price.amount)
                .font(.driveTitle1)
                .fontWeight(.bold)
                .gradientText(isSelected ? .drivePrimary : LinearGradient(colors: [.driveTextPrimary, .driveTextSecondary], startPoint: .leading, endPoint: .trailing))
            
            if let suffix = price.suffix {
                Text(suffix)
                    .font(.driveSubheadline)
                    .foregroundColor(.driveTextSecondary)
            }
            
            Spacer()
            
            if let originalPrice = price.originalAmount {
                Text(originalPrice)
                    .font(.driveCallout)
                    .foregroundColor(.driveTextTertiary)
                    .strikethrough(true, color: .driveTextTertiary)
            }
        }
    }
}

// MARK: - Plan Item Model

struct PlanFeature {
    let title: String
    let included: Bool
}

struct PlanPrice {
    let prefix: String?
    let amount: String
    let suffix: String?
    let originalAmount: String?
    
    init(prefix: String? = nil, amount: String, suffix: String? = nil, originalAmount: String? = nil) {
        self.prefix = prefix
        self.amount = amount
        self.suffix = suffix
        self.originalAmount = originalAmount
    }
}

struct PlanItem: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String?
    let features: [PlanFeature]
    let price: PlanPrice?
    let isPopular: Bool
    
    init(
        name: String,
        subtitle: String? = nil,
        features: [PlanFeature] = [],
        price: PlanPrice? = nil,
        isPopular: Bool = false
    ) {
        self.name = name
        self.subtitle = subtitle
        self.features = features
        self.price = price
        self.isPopular = isPopular
    }
}

// MARK: - Preview

#Preview {
    let samplePlan = PlanItem(
        name: "Pro Plan",
        subtitle: "Everything you need to level up",
        features: [
            PlanFeature(title: "Unlimited tasks", included: true),
            PlanFeature(title: "Priority support", included: true),
            PlanFeature(title: "Advanced analytics", included: true),
            PlanFeature(title: "Custom integrations", included: false),
        ],
        price: PlanPrice(prefix: "$", amount: "9", suffix: "/mo", originalAmount: "$19/mo"),
        isPopular: true
    )
    
    let freePlan = PlanItem(
        name: "Free",
        subtitle: "Get started",
        features: [
            PlanFeature(title: "5 tasks per day", included: true),
            PlanFeature(title: "Basic analytics", included: true),
            PlanFeature(title: "Priority support", included: false),
        ],
        price: PlanPrice(amount: "Free")
    )
    
    VStack(spacing: DriveSpacing.base) {
        PlanCard(plan: freePlan, isSelected: false, onSelect: {})
        
        PlanCard(plan: samplePlan, isSelected: true, onSelect: {})
    }
    .padding()
    .background(Color.driveBackground)
}
