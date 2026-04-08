import SwiftUI

struct StreakDisplay: View {
    let count: Int
    let label: String?
    
    @State private var fireScale: CGFloat = 1.0
    @State private var fireOpacity: Double = 1.0
    @State private var particleOffset: CGFloat = 0
    @State private var glowPulse: Double = 0.3
    
    var body: some View {
        HStack(spacing: DriveSpacing.sm) {
            fireIcon
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text("\(count)")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .gradientText(.driveVibrant)
                    
                    Text("day")
                        .font(.driveCallout)
                        .foregroundColor(.driveTextSecondary)
                }
                
                if let label = label {
                    Text(label)
                        .font(.driveCaption)
                        .foregroundColor(.driveTextTertiary)
                }
            }
        }
        .padding(.horizontal, DriveSpacing.base)
        .padding(.vertical, DriveSpacing.md)
        .glassMorphism(
            backgroundOpacity: 0.05,
            borderOpacity: 0.15,
            cornerRadius: DriveRadius.xl
        )
        .overlay(
            GeometryReader { geo in
                ZStack {
                    ForEach(0..<5) { i in
                        fireParticle(index: i)
                            .offset(
                                x: CGFloat.random(in: -10...10),
                                y: -particleOffset - CGFloat(i) * 8
                            )
                            .opacity(fireOpacity * (1.0 - Double(i) * 0.15))
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .opacity(count > 0 ? 1 : 0)
        )
        .glow(color: .drivePurple, radius: 15, intensity: glowPulse)
        .onAppear {
            animateFire()
        }
    }
    
    // MARK: - Fire Icon
    
    private var fireIcon: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.driveWarning.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 5,
                        endRadius: 25
                    )
                )
                .frame(width: 50, height: 50)
                .scaleEffect(fireScale)
            
            Image(systemName: count >= 7 ? "flame.fill" : "fire")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: count >= 7 ? [.driveWarning, .driveError, .drivePink] : [.driveWarning, .driveError],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .scaleEffect(fireScale)
        }
    }
    
    // MARK: - Fire Particles
    
    private func fireParticle(index: Int) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [.driveWarning, .driveError.opacity(0.5), .clear],
                    center: .center,
                    startRadius: 1,
                    endRadius: 4
                )
            )
            .frame(width: 4, height: 4)
            .offset(x: CGFloat.random(in: -15...15), y: 0)
    }
    
    // MARK: - Animations
    
    private func animateFire() {
        withAnimation(DriveAnimations.pulse) {
            fireScale = 1.1
        }
        
        withAnimation(DriveAnimations.pulse.delay(0.2)) {
            glowPulse = 0.6
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            withAnimation(DriveAnimations.fast) {
                particleOffset += 5
                fireOpacity = Double.random(in: 0.7...1.0)
            }
        }
    }
}

// MARK: - Compact Variant

struct StreakDisplayCompact: View {
    let count: Int
    
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        HStack(spacing: DriveSpacing.xs) {
            Image(systemName: count >= 7 ? "flame.fill" : "fire")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.driveWarning, .driveError],
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .scaleEffect(pulseScale)
            
            Text("\(count)")
                .font(.driveFootnote)
                .fontWeight(.semibold)
                .foregroundColor(.driveTextPrimary)
        }
        .padding(.horizontal, DriveSpacing.sm)
        .padding(.vertical, DriveSpacing.xs)
        .background(
            Capsule()
                .fill(Color.driveGlassBackground)
                .overlay(
                    Capsule()
                        .strokeBorder(Color.driveGlassBorder, lineWidth: 1)
                )
        )
        .onAppear {
            withAnimation(DriveAnimations.pulse) {
                pulseScale = 1.15
            }
        }
    }
}

// MARK: - Large Variant

struct StreakDisplayLarge: View {
    let count: Int
    let milestone: String?
    
    @State private var energyRings: [Double] = [0, 0, 0]
    @State private var mainScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: DriveSpacing.md) {
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .strokeBorder(
                            LinearGradient(
                                colors: [.driveWarning.opacity(0.3 - Double(index) * 0.08), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 120 + CGFloat(index) * 30, height: 120 + CGFloat(index) * 30)
                        .scaleEffect(energyRings[index] > 0 ? 1.0 + energyRings[index] * 0.1 : 1.0)
                        .opacity(energyRings[index])
                }
                
                VStack(spacing: DriveSpacing.xs) {
                    Image(systemName: count >= 14 ? "flame.fill" : (count >= 7 ? "fire" : "sparkle"))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: count >= 14 ?
                                    [.driveWarning, .driveError, .drivePink] :
                                    (count >= 7 ? [.driveWarning, .driveError] : [.drivePurple, .driveBlue]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .scaleEffect(mainScale)
                        .glow(color: .driveWarning, radius: 20, intensity: 0.5)
                    
                    Text("\(count)")
                        .font(.system(size: 42, weight: .bold, design: .default))
                        .gradientText(.driveVibrant)
                    
                    Text("Day Streak")
                        .font(.driveCallout)
                        .foregroundColor(.driveTextSecondary)
                }
            }
            
            if let milestone = milestone {
                Text(milestone)
                    .font(.driveFootnote)
                    .foregroundColor(.driveWarning)
                    .padding(.horizontal, DriveSpacing.base)
                    .padding(.vertical, DriveSpacing.xs)
                    .background(
                        Capsule()
                            .fill(.driveWarning.opacity(0.15))
                    )
            }
        }
        .padding(DriveSpacing.xl)
        .glassMorphism(
            backgroundOpacity: 0.05,
            borderOpacity: 0.15,
            cornerRadius: DriveRadius.xxl
        )
        .onAppear {
            animateEnergyRings()
        }
    }
    
    private func animateEnergyRings() {
        withAnimation(DriveAnimations.bouncy) {
            mainScale = 1.05
        }
        
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                withAnimation(DriveAnimations.slow.repeatForever(autoreverses: true)) {
                    energyRings[i] = 1.0
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: DriveSpacing.xxl) {
        StreakDisplay(count: 5, label: "Keep it going!")
        
        StreakDisplayCompact(count: 12)
        
        StreakDisplayLarge(count: 21, milestone: "🔥 3 Week Champion!")
    }
    .padding()
    .background(Color.driveBackground)
}
