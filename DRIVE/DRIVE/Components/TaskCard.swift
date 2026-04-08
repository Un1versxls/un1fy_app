import SwiftUI

struct TaskCard: View {
    let task: TaskItem
    let onTap: () -> Void
    
    @State private var isPressed = false
    @State private var isHovering = false
    @State private var showCompletion = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: DriveSpacing.base) {
                taskIcon
                
                VStack(alignment: .leading, spacing: DriveSpacing.xs) {
                    HStack {
                        Text(task.title)
                            .font(.driveHeadline)
                            .foregroundColor(task.isCompleted ? .driveTextTertiary : .driveTextPrimary)
                            .strikethrough(task.isCompleted, color: .driveTextTertiary)
                        
                        Spacer()
                        
                        if task.isCompleted {
                            completionBadge
                        } else if let points = task.points {
                            pointsBadge(points: points)
                        }
                    }
                    
                    if let description = task.description {
                        Text(description)
                            .font(.driveSubheadline)
                            .foregroundColor(.driveTextSecondary)
                            .lineLimit(2)
                    }
                    
                    if !task.isCompleted {
                        taskProgressBar
                    }
                }
            }
            .padding(DriveSpacing.base)
            .glassMorphism(
                backgroundOpacity: task.isCompleted ? 0.02 : 0.04,
                borderOpacity: task.isCompleted ? 0.05 : 0.12,
                cornerRadius: DriveRadius.lg
            )
            .overlay(
                RoundedRectangle(cornerRadius: DriveRadius.lg)
                    .fill(.driveSuccess.opacity(0.1))
                    .opacity(showCompletion ? 1 : 0)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            guard !task.isCompleted else { return }
            withAnimation(DriveAnimations.standard) {
                isHovering = hovering
            }
        }
        .onChange(of: task.isCompleted) { _, completed in
            if completed {
                triggerCompletionAnimation()
            }
        }
    }
    
    // MARK: - Task Icon
    
    private var taskIcon: some View {
        ZStack {
            Circle()
                .fill(
                    task.isCompleted ?
                    LinearGradient(colors: [.driveSuccess, .driveCyan], startPoint: .top, endPoint: .bottom) :
                    LinearGradient(colors: [.drivePurple, .driveBlue], startPoint: .top, endPoint: .bottom)
                )
                .frame(width: 48, height: 48)
            
            if task.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Image(systemName: task.icon ?? "list.bullet")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .glow(
            color: task.isCompleted ? .driveSuccess : .drivePurple,
            radius: isHovering ? 15 : 8,
            intensity: isHovering ? 0.5 : 0.3
        )
    }
    
    // MARK: - Completion Badge
    
    private var completionBadge: some View {
        HStack(spacing: DriveSpacing.xxs) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 12))
            Text("Done")
                .font(.driveCaption)
        }
        .foregroundColor(.driveSuccess)
        .padding(.horizontal, DriveSpacing.sm)
        .padding(.vertical, DriveSpacing.xxs)
        .background(
            Capsule()
                .fill(.driveSuccess.opacity(0.15))
        )
    }
    
    // MARK: - Points Badge
    
    private func pointsBadge(points: Int) -> some View {
        HStack(spacing: DriveSpacing.xxs) {
            Image(systemName: "star.fill")
                .font(.system(size: 10))
            Text("+\(points)")
                .font(.driveCaption)
        }
        .foregroundColor(.driveWarning)
        .padding(.horizontal, DriveSpacing.sm)
        .padding(.vertical, DriveSpacing.xxs)
        .background(
            Capsule()
                .fill(.driveWarning.opacity(0.15))
        )
    }
    
    // MARK: - Progress Bar
    
    private var taskProgressBar: some View {
        VStack(spacing: DriveSpacing.xxs) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: DriveRadius.pill)
                    .fill(Color.driveSurfaceElevated)
                    .frame(height: 4)
                
                RoundedRectangle(cornerRadius: DriveRadius.pill)
                    .fill(.drivePrimary)
                    .frame(width: CGFloat(task.progress) * UIScreen.main.bounds.width * 0.5, height: 4)
            }
            
            Text("\(Int(task.progress * 100))%")
                .font(.driveCaption)
                .foregroundColor(.driveTextTertiary)
        }
    }
    
    // MARK: - Completion Animation
    
    private func triggerCompletionAnimation() {
        withAnimation(DriveAnimations.bouncy) {
            showCompletion = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(DriveAnimations.smooth) {
                showCompletion = false
            }
        }
    }
}

// MARK: - Task Item Model

struct TaskItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String?
    let icon: String?
    let points: Int?
    var progress: Double
    var isCompleted: Bool
    
    init(
        title: String,
        description: String? = nil,
        icon: String? = nil,
        points: Int? = nil,
        progress: Double = 0,
        isCompleted: Bool = false
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.points = points
        self.progress = progress
        self.isCompleted = isCompleted
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: DriveSpacing.base) {
        TaskCard(
            task: TaskItem(
                title: "Complete Daily Challenge",
                description: "Finish 3 tasks to earn bonus points",
                icon: "bolt.fill",
                points: 50,
                progress: 0.6
            ),
            onTap: {}
        )
        
        TaskCard(
            task: TaskItem(
                title: "Morning Routine",
                description: "Completed",
                icon: "sun.max.fill",
                points: 25,
                progress: 1.0,
                isCompleted: true
            ),
            onTap: {}
        )
        
        TaskCard(
            task: TaskItem(
                title: "Weekly Goal",
                icon: "target",
                points: 100,
                progress: 0.3
            ),
            onTap: {}
        )
    }
    .padding()
    .background(Color.driveBackground)
}
