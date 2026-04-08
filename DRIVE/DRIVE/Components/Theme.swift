import SwiftUI

// MARK: - Color Palette

extension Color {
    static let driveBackground = Color(hex: "0F0F0F")
    static let driveSurface = Color(hex: "1A1A1A")
    static let driveSurfaceElevated = Color(hex: "242424")
    
    static let drivePurple = Color(hex: "8B5CF6")
    static let driveBlue = Color(hex: "3B82F6")
    static let drivePink = Color(hex: "EC4899")
    static let driveCyan = Color(hex: "06B6D4")
    
    static let driveTextPrimary = Color.white
    static let driveTextSecondary = Color(hex: "A1A1AA")
    static let driveTextTertiary = Color(hex: "71717A")
    
    static let driveSuccess = Color(hex: "10B981")
    static let driveWarning = Color(hex: "F59E0B")
    static let driveError = Color(hex: "EF4444")
    
    static let driveGlassBackground = Color.white.opacity(0.03)
    static let driveGlassBorder = Color.white.opacity(0.1)
    static let driveGlassBorderLight = Color.white.opacity(0.05)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Gradients

extension LinearGradient {
    static let drivePrimary = LinearGradient(
        colors: [.drivePurple, .driveBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let driveVibrant = LinearGradient(
        colors: [.drivePurple, .drivePink, .driveBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let driveSubtle = LinearGradient(
        colors: [.drivePurple.opacity(0.8), .driveBlue.opacity(0.8)],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let driveSuccess = LinearGradient(
        colors: [.driveSuccess, .driveCyan],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let driveGlow = LinearGradient(
        colors: [.drivePurple.opacity(0.4), .driveBlue.opacity(0.4), .drivePurple.opacity(0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

// MARK: - Typography

struct DriveTypography {
    struct Sizes {
        static let largeTitle: CGFloat = 34
        static let title1: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subheadline: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption1: CGFloat = 12
        static let caption2: CGFloat = 11
    }
    
    struct Weights {
        static let bold: Font.Weight = .bold
        static let semibold: Font.Weight = .semibold
        static let medium: Font.Weight = .medium
        static let regular: Font.Weight = .regular
        static let light: Font.Weight = .light
    }
}

extension Font {
    static let driveLargeTitle = Font.system(size: DriveTypography.Sizes.largeTitle, weight: .bold, design: .default)
    static let driveTitle1 = Font.system(size: DriveTypography.Sizes.title1, weight: .bold, design: .default)
    static let driveTitle2 = Font.system(size: DriveTypography.Sizes.title2, weight: .semibold, design: .default)
    static let driveTitle3 = Font.system(size: DriveTypography.Sizes.title3, weight: .semibold, design: .default)
    static let driveHeadline = Font.system(size: DriveTypography.Sizes.headline, weight: .semibold, design: .default)
    static let driveBody = Font.system(size: DriveTypography.Sizes.body, weight: .regular, design: .default)
    static let driveCallout = Font.system(size: DriveTypography.Sizes.callout, weight: .medium, design: .default)
    static let driveSubheadline = Font.system(size: DriveTypography.Sizes.subheadline, weight: .regular, design: .default)
    static let driveFootnote = Font.system(size: DriveTypography.Sizes.footnote, weight: .medium, design: .default)
    static let driveCaption = Font.system(size: DriveTypography.Sizes.caption1, weight: .medium, design: .default)
}

// MARK: - Spacing

struct DriveSpacing {
    static let none: CGFloat = 0
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let base: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let xxxl: CGFloat = 40
    static let huge: CGFloat = 48
    static let massive: CGFloat = 64
}

// MARK: - Corner Radius

struct DriveRadius {
    static let xs: CGFloat = 6
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let pill: CGFloat = 9999
}

// MARK: - Shadows & Glows

struct DriveShadows {
    static let soft = ShadowStyle(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
    static let medium = ShadowStyle(color: .black.opacity(0.4), radius: 20, x: 0, y: 8)
    static let large = ShadowStyle(color: .black.opacity(0.5), radius: 40, x: 0, y: 16)
    
    static let purpleGlow = ShadowStyle(color: .drivePurple.opacity(0.5), radius: 20, x: 0, y: 0)
    static let blueGlow = ShadowStyle(color: .driveBlue.opacity(0.5), radius: 20, x: 0, y: 0)
    static let primaryGlow = ShadowStyle(color: .drivePurple.opacity(0.4), radius: 25, x: 0, y: 0)
}

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - Animation Curves

struct DriveAnimations {
    static let fast = Animation.spring(response: 0.3, dampingFraction: 0.8, blendDuration: 0.2)
    static let standard = Animation.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.3)
    static let slow = Animation.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.4)
    static let bouncy = Animation.spring(response: 0.6, dampingFraction: 0.5, blendDuration: 0.5)
    static let smooth = Animation.easeInOut(duration: 0.35)
    static let pulse = Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)
    static let shimmer = Animation.linear(duration: 1.5).repeatForever(autoreverses: false)
}

// MARK: - Glass Morphism Modifier

struct GlassMorphism: ViewModifier {
    var backgroundOpacity: Double = 0.03
    var borderOpacity: Double = 0.1
    var cornerRadius: CGFloat = DriveRadius.lg
    var blurRadius: CGFloat = 20
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(backgroundOpacity)
            )
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.driveGlassBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(borderOpacity),
                                Color.white.opacity(borderOpacity * 0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func glassMorphism(
        backgroundOpacity: Double = 0.03,
        borderOpacity: Double = 0.1,
        cornerRadius: CGFloat = DriveRadius.lg
    ) -> some View {
        modifier(GlassMorphism(
            backgroundOpacity: backgroundOpacity,
            borderOpacity: borderOpacity,
            cornerRadius: cornerRadius
        ))
    }
}

// MARK: - Gradient Text Modifier

struct GradientText: ViewModifier {
    let gradient: LinearGradient
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(gradient)
    }
}

extension View {
    func gradientText(_ gradient: LinearGradient = .drivePrimary) -> some View {
        modifier(GradientText(gradient: gradient))
    }
}

// MARK: - Glow Effect Modifier

struct GlowEffect: ViewModifier {
    let color: Color
    let radius: CGFloat
    let intensity: Double
    
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(intensity), radius: radius * 0.5, x: 0, y: 0)
            .shadow(color: color.opacity(intensity * 0.5), radius: radius, x: 0, y: 0)
    }
}

extension View {
    func glow(color: Color = .drivePurple, radius: CGFloat = 20, intensity: Double = 0.5) -> some View {
        modifier(GlowEffect(color: color, radius: radius, intensity: intensity))
    }
}
