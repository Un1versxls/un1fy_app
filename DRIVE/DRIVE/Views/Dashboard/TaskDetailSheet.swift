import SwiftUI

struct TaskDetailSheet: View {
    @StateObject private var viewModel: TaskViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(task: DailyTask) {
        _viewModel = StateObject(wrappedValue: TaskViewModel(appState: AppState.shared))
        viewModel.selectTask(task)
    }
    
    var body: some View {
        ZStack {
            Color.driveBackground
                .ignoresSafeArea()
            
            VStack(spacing: DriveSpacing.xl) {
                headerSection
                
                taskContent
                
                if viewModel.isTimerRunning || viewModel.timerSeconds > 0 {
                    timerSection
                }
                
                Spacer()
                
                actionButtons
            }
            .padding(DriveSpacing.base)
        }
        .onReceive(viewModel.timer) { _ in
            if viewModel.isTimerRunning {
                viewModel.timerSeconds += 1
            }
        }
        .alert("Skip Task?", isPresented: $viewModel.showSkipConfirmation) {
            Button("Skip", role: .destructive) {
                viewModel.skipSelectedTask()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to skip this task? You won't receive points.")
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.driveTextSecondary)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.driveSurfaceElevated)
                    )
            }
            
            Spacer()
            
            Text("Task Details")
                .font(.driveHeadline)
                .foregroundColor(.driveTextPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 32, height: 32)
        }
    }
    
    // MARK: - Task Content
    
    private var taskContent: some View {
        VStack(spacing: DriveSpacing.lg) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.drivePurple, .driveBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white)
            }
            .glow(color: .drivePurple, radius: 15, intensity: 0.4)
            
            VStack(spacing: DriveSpacing.sm) {
                Text(viewModel.selectedTask?.title ?? "")
                    .font(.driveTitle2)
                    .foregroundColor(.driveTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text(viewModel.selectedTask?.description ?? "")
                    .font(.driveSubheadline)
                    .foregroundColor(.driveTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: DriveSpacing.xl) {
                infoChip(icon: "star.fill", value: viewModel.selectedTask?.pointsLabel ?? "0", color: .driveWarning)
                infoChip(icon: "clock", value: viewModel.selectedTask?.timeLabel ?? "00:00", color: .driveCyan)
                infoChip(icon: "folder.fill", value: viewModel.selectedTask?.niche ?? "General", color: .drivePurple)
            }
        }
        .padding(DriveSpacing.base)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.xl
        )
    }
    
    private var categoryIcon: String {
        guard let task = viewModel.selectedTask else { return "bolt.fill" }
        switch task.category {
        case .quick:
            return "bolt.fill"
        case .engagement:
            return "bubble.left.and.bubble.right.fill"
        case .creation:
            return "wand.and.stars"
        case .research:
            return "magnifyingglass"
        case .admin:
            return "doc.text.fill"
        }
    }
    
    private func infoChip(icon: String, value: String, color: Color) -> some View {
        VStack(spacing: DriveSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
            
            Text(value)
                .font(.driveSubheadline)
                .foregroundColor(.driveTextPrimary)
        }
    }
    
    // MARK: - Timer Section
    
    private var timerSection: some View {
        VStack(spacing: DriveSpacing.md) {
            Text(viewModel.timeLabel)
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(.driveTextPrimary)
                .gradientText(viewModel.isTimerRunning ? .drivePrimary : LinearGradient(colors: [.driveTextSecondary, .driveTextTertiary], startPoint: .leading, endPoint: .trailing))
            
            HStack(spacing: DriveSpacing.base) {
                if !viewModel.isTimerRunning {
                    Button {
                        viewModel.toggleTimer()
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Timer")
                        }
                        .font(.driveHeadline)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DriveRadius.lg)
                                .fill(.drivePrimary)
                        )
                    }
                } else {
                    Button {
                        viewModel.toggleTimer()
                    } label: {
                        HStack {
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .font(.driveHeadline)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DriveRadius.lg)
                                .fill(.driveWarning)
                        )
                    }
                }
                
                if viewModel.timerSeconds > 0 {
                    Button {
                        viewModel.resetTimer()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset")
                        }
                        .font(.driveHeadline)
                        .foregroundColor(.driveTextSecondary)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DriveRadius.lg)
                                .fill(Color.driveSurfaceElevated)
                        )
                    }
                }
            }
        }
        .padding(DriveSpacing.base)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.lg
        )
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: DriveSpacing.base) {
            GradientButton(
                "Complete Task",
                icon: "checkmark",
                gradient: .driveSuccess
            ) {
                viewModel.completeSelectedTask()
                dismiss()
            }
            
            GradientOutlineButton("Skip Task") {
                viewModel.showSkipConfirmation = true
            }
        }
    }
}

#Preview {
    TaskDetailSheet(
        task: DailyTask(
            title: "Schedule 3 posts for tomorrow",
            description: "Use your scheduling tool to queue posts for peak engagement times",
            points: 15,
            estimatedSeconds: 60,
            niche: "Social Media Manager"
        )
    )
}
    
    var body: some View {
        ZStack {
            Color.driveBackground
                .ignoresSafeArea()
            
            VStack(spacing: DriveSpacing.xl) {
                headerSection
                
                taskContent
                
                if viewModel.isTimerRunning || viewModel.timerSeconds > 0 {
                    timerSection
                }
                
                Spacer()
                
                actionButtons
            }
            .padding(DriveSpacing.base)
        }
        .onReceive(viewModel.timer) { _ in
            if viewModel.isTimerRunning {
                viewModel.timerSeconds += 1
            }
        }
        .alert("Skip Task?", isPresented: $viewModel.showSkipConfirmation) {
            Button("Skip", role: .destructive) {
                viewModel.skipSelectedTask()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to skip this task? You won't receive points.")
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.driveTextSecondary)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(Color.driveSurfaceElevated)
                    )
            }
            
            Spacer()
            
            Text("Task Details")
                .font(.driveHeadline)
                .foregroundColor(.driveTextPrimary)
            
            Spacer()
            
            Color.clear
                .frame(width: 32, height: 32)
        }
    }
    
    // MARK: - Task Content
    
    private var taskContent: some View {
        VStack(spacing: DriveSpacing.lg) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.drivePurple, .driveBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.white)
            }
            .glow(color: .drivePurple, radius: 15, intensity: 0.4)
            
            VStack(spacing: DriveSpacing.sm) {
                Text(selectedTask.title)
                    .font(.driveTitle2)
                    .foregroundColor(.driveTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text(selectedTask.description)
                    .font(.driveSubheadline)
                    .foregroundColor(.driveTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: DriveSpacing.xl) {
                infoChip(icon: "star.fill", value: selectedTask.pointsLabel, color: .driveWarning)
                infoChip(icon: "clock", value: selectedTask.timeLabel, color: .driveCyan)
                infoChip(icon: "folder.fill", value: selectedTask.niche, color: .drivePurple)
            }
        }
        .padding(DriveSpacing.base)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.xl
        )
    }
    
    private var categoryIcon: String {
        switch selectedTask.category {
        case .quick:
            return "bolt.fill"
        case .engagement:
            return "bubble.left.and.bubble.right.fill"
        case .creation:
            return "wand.and.stars"
        case .research:
            return "magnifyingglass"
        case .admin:
            return "doc.text.fill"
        }
    }
    
    private func infoChip(icon: String, value: String, color: Color) -> some View {
        VStack(spacing: DriveSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
            
            Text(value)
                .font(.driveSubheadline)
                .foregroundColor(.driveTextPrimary)
        }
    }
    
    // MARK: - Timer Section
    
    private var timerSection: some View {
        VStack(spacing: DriveSpacing.md) {
            Text(formatTime(timerSeconds))
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .foregroundColor(.driveTextPrimary)
                .gradientText(isTimerRunning ? .drivePrimary : LinearGradient(colors: [.driveTextSecondary, .driveTextTertiary], startPoint: .leading, endPoint: .trailing))
            
            HStack(spacing: DriveSpacing.base) {
                if !isTimerRunning {
                    Button {
                        withAnimation(DriveAnimations.standard) {
                            isTimerRunning = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start Timer")
                        }
                        .font(.driveHeadline)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DriveRadius.lg)
                                .fill(.drivePrimary)
                        )
                    }
                } else {
                    Button {
                        withAnimation(DriveAnimations.standard) {
                            isTimerRunning = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: "pause.fill")
                            Text("Pause")
                        }
                        .font(.driveHeadline)
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DriveRadius.lg)
                                .fill(.driveWarning)
                        )
                    }
                }
                
                if timerSeconds > 0 {
                    Button {
                        withAnimation(DriveAnimations.standard) {
                            timerSeconds = 0
                            isTimerRunning = false
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset")
                        }
                        .font(.driveHeadline)
                        .foregroundColor(.driveTextSecondary)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: DriveRadius.lg)
                                .fill(Color.driveSurfaceElevated)
                        )
                    }
                }
            }
        }
        .padding(DriveSpacing.base)
        .glassMorphism(
            backgroundOpacity: 0.04,
            borderOpacity: 0.1,
            cornerRadius: DriveRadius.lg
        )
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    // MARK: - Action Buttons
    
    private var actionButtons: some View {
        VStack(spacing: DriveSpacing.base) {
            GradientButton(
                "Complete Task",
                icon: "checkmark",
                gradient: .driveSuccess
            ) {
                onComplete(selectedTask)
                dismiss()
            }
            
            GradientOutlineButton("Skip Task") {
                showSkipConfirmation = true
            }
        }
    }
}

#Preview {
    TaskDetailSheet(
        task: DailyTask(
            title: "Schedule 3 posts for tomorrow",
            description: "Use your scheduling tool to queue posts for peak engagement times",
            points: 15,
            estimatedSeconds: 60,
            niche: "Social Media Manager"
        ),
        onComplete: { _ in },
        onSkip: { _ in }
    )
}
