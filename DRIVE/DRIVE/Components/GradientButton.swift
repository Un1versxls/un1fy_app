import SwiftUI

struct GradientButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovering = false
    @State private var glowIntensity: Double = 0.3
    
    var gradient: LinearGradient = .drivePrimary
    var isEnabled: Bool = true
    var fullWidth: Bool = true
    var height: CGFloat = 56
    var cornerRadius: CGFloat = DriveRadius.lg
    
    init(
        _ title: String,
        icon: String? = nil,
        gradient: LinearGradient = .drivePrimary,
        isEnabled: Bool = true,
        fullWidth: Bool = true,
        height: CGFloat = 56,
        cornerRadius: CGFloat = DriveRadius.lg,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.gradient = gradient
        self.isEnabled = isEnabled
        self.fullWidth = fullWidth
        self.height = height
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            guard isEnabled else { return }
            withAnimation(DriveAnimations.fast) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(DriveAnimations.fast) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: DriveSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text(title)
                    .font(.driveHeadline)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .frame(height: height)
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isEnabled ? gradient : LinearGradient(colors: [.driveSurfaceElevated, .driveSurface], startPoint: .leading, endPoint: .trailing))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        isEnabled ? Color.white.opacity(0.2) : Color.clear,
                        lineWidth: 1
                    )
            )
            .glow(
                color: .drivePurple,
                radius: isHovering ? 25 : 15,
                intensity: glowIntensity
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.5)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .onHover { hovering in
            guard isEnabled else { return }
            withAnimation(DriveAnimations.standard) {
                isHovering = hovering
                glowIntensity = hovering ? 0.6 : 0.3
            }
        }
    }
}

// MARK: - Outline Variant

struct GradientOutlineButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovering = false
    
    init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            withAnimation(DriveAnimations.fast) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(DriveAnimations.fast) {
                    isPressed = false
                }
                action()
            }
        }) {
            HStack(spacing: DriveSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text(title)
                    .font(.driveHeadline)
                    .fontWeight(.semibold)
                    .gradientText(.drivePrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: DriveRadius.lg)
                    .fill(Color.driveGlassBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: DriveRadius.lg)
                    .strokeBorder(
                        LinearGradient(
                            colors: isHovering ? [.drivePurple, .driveBlue] : [.driveGlassBorder, .driveGlassBorder],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isHovering ? 2 : 1
                    )
            )
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(DriveAnimations.standard) {
                isHovering = hovering
            }
        }
    }
}

// MARK: - Icon Button

struct GradientIconButton: View {
    let icon: String
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovering = false
    
    var size: CGFloat = 48
    
    var body: some View {
        Button(action: {
            withAnimation(DriveAnimations.fast) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(DriveAnimations.fast) {
                    isPressed = false
                }
                action()
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(.drivePrimary)
                )
                .glow(color: .drivePurple, radius: isHovering ? 15 : 8, intensity: isHovering ? 0.5 : 0.3)
                .scaleEffect(isPressed ? 0.9 : (isHovering ? 1.1 : 1.0))
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(DriveAnimations.standard) {
                isHovering = hovering
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: DriveSpacing.xl) {
        GradientButton("Get Started", icon: "arrow.right")
        
        GradientButton("Secondary Action", isEnabled: false)
        
        GradientOutlineButton("Learn More", icon: "info.circle")
        
        HStack(spacing: DriveSpacing.base) {
            GradientIconButton(icon: "heart.fill")
            GradientIconButton(icon: "bookmark.fill")
            GradientIconButton(icon: "share")
        }
    }
    .padding()
    .background(Color.driveBackground)
}
