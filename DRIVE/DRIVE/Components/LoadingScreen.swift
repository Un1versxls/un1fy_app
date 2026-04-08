import SwiftUI

struct LoadingScreen: View {
    @Binding var isLoading: Bool
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var progress: CGFloat = 0
    @State private var dotIndex = 0
    @State private var subtitleOpacity: Double = 0
    @State private var glowIntensity: Double = 0.3
    
    var completion: (() -> Void)?
    
    private let dots = ["", ".", "..", "..."]
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            VStack(spacing: DriveSpacing.xxl) {
                Spacer()
                
                logoSection
                
                progressBarSection
                
                Spacer()
                
                versionLabel
            }
        }
        .onAppear {
            animateIn()
            simulateLoading()
        }
    }
    
    // MARK: - Logo Section
    
    private var logoSection: some View {
        VStack(spacing: DriveSpacing.md) {
            Text("DRIVE")
                .font(.system(size: 64, weight: .bold, design: .default))
                .gradientText(.driveVibrant)
                .scaleEffect(logoScale)
                .opacity(logoOpacity)
                .glow(color: .drivePurple, radius: 30, intensity: glowIntensity)
            
            Text("Elevate your workflow")
                .font(.driveCallout)
                .foregroundColor(.driveTextSecondary)
                .opacity(subtitleOpacity)
        }
    }
    
    // MARK: - Progress Bar Section
    
    private var progressBarSection: some View {
        VStack(spacing: DriveSpacing.base) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: DriveRadius.pill)
                    .fill(Color.driveSurfaceElevated)
                    .frame(height: 6)
                
                RoundedRectangle(cornerRadius: DriveRadius.pill)
                    .fill(.drivePrimary)
                    .frame(width: progress * UIScreen.main.bounds.width * 0.6, height: 6)
                    .glow(color: .drivePurple, radius: 10, intensity: 0.6)
            }
            .frame(width: UIScreen.main.bounds.width * 0.6)
            
            HStack(spacing: DriveSpacing.xs) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index <= dotIndex ? .drivePurple : .driveTextTertiary)
                        .frame(width: 8, height: 8)
                        .scaleEffect(index <= dotIndex ? 1.2 : 0.8)
                        .animation(DriveAnimations.fast, value: dotIndex)
                }
            }
            .padding(.top, DriveSpacing.sm)
        }
    }
    
    // MARK: - Version Label
    
    private var versionLabel: some View {
        Text("v1.0.0")
            .font(.driveCaption)
            .foregroundColor(.driveTextTertiary)
            .padding(.bottom, DriveSpacing.xxl)
    }
    
    // MARK: - Animations
    
    private func animateIn() {
        withAnimation(DriveAnimations.bouncy.delay(0.2)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        withAnimation(DriveAnimations.smooth.delay(0.5)) {
            subtitleOpacity = 1.0
        }
        
        withAnimation(DriveAnimations.pulse.delay(0.8)) {
            glowIntensity = 0.5
        }
        
        animateDots()
    }
    
    private func animateDots() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            guard isLoading else {
                timer.invalidate()
                return
            }
            withAnimation(DriveAnimations.fast) {
                dotIndex = (dotIndex + 1) % 4
            }
        }
    }
    
    private func simulateLoading() {
        let duration: TimeInterval = 2.5
        let interval: TimeInterval = 0.05
        let increment = interval / duration
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            guard isLoading else {
                timer.invalidate()
                return
            }
            
            withAnimation(.linear(duration: interval)) {
                progress = min(progress + increment, 1.0)
            }
            
            if progress >= 1.0 {
                timer.invalidate()
                withAnimation(DriveAnimations.standard) {
                    isLoading = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    completion?()
                }
            }
        }
    }
}

// MARK: - Background Gradient

struct BackgroundGradient: View {
    @State private var offset: CGFloat = -0.5
    
    var body: some View {
        LinearGradient(
            colors: [
                Color.driveBackground,
                Color(hex: "1A1025"),
                Color.driveBackground
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .overlay(
            RadialGradient(
                colors: [.drivePurple.opacity(0.15), .clear],
                center: .center,
                startRadius: 50,
                endRadius: 300
            )
            .offset(x: 0, y: offset * 100)
            .animation(DriveAnimations.slow.repeatForever(autoreverses: true), value: offset)
        )
        .onAppear {
            offset = 0.5
        }
    }
}

// MARK: - Preview

#Preview {
    LoadingScreen(isLoading: .constant(true))
}
