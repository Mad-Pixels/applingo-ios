import SwiftUI

struct PreviewContainerView<Content: View>: View {
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var errorManager = ErrorManager.shared
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .environmentObject(themeManager)
            .environmentObject(errorManager)
    }
}

struct BaseScreenPreview<Content: View>: View {
    let style: BaseScreenStyle
    let content: Content
    let screen: ScreenType
    let theme: ThemeType
    let error: AppError?
   
    init(
        theme: ThemeType = .light,
        style: BaseScreenStyle = .default,
        screen: ScreenType,
        error: AppError? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.screen = screen
        self.error = error
        self.content = content()
        
        ThemeManager.shared.setTheme(to: theme)
        if let error = error {
            ErrorManager.shared.currentError = error
        }
    }
    
    var body: some View {
        NavigationView {
            content
                .id(theme)
                .background(ThemeManager.shared.currentThemeStyle.backgroundPrimary)
                .preferredColorScheme(theme == .dark ? .dark : .light)
                .withScreenTracker(screen)
                .withLocaleTracker()
                .withThemeTracker()
                .withErrorTracker(screen)
        }
    }
}

#Preview("Light Theme") {
    PreviewContainerView {
        BaseScreenPreview(theme: .light, screen: .settings) {
            VStack(spacing: 20) {
                Text("Content Example")
                    .foregroundColor(ThemeManager.shared.currentThemeStyle.textPrimary)
                .foregroundColor(ThemeManager.shared.currentThemeStyle.accentPrimary)
            }
            .padding()
        }
    }
}

#Preview("Dark Theme") {
    PreviewContainerView {
        BaseScreenPreview(theme: .dark, screen: .words) {
            VStack(spacing: 20) {
                Text("Content Example")
                    .foregroundColor(ThemeManager.shared.currentThemeStyle.textPrimary)
                .foregroundColor(ThemeManager.shared.currentThemeStyle.accentPrimary)
            }
            .padding()
        }
    }
}

#Preview("Alert Error") {
    PreviewContainerView {
        BaseScreenPreview(
            theme: .light,
            screen: .words,
            error: AppError(
                type: .network(statusCode: 404),
                context: AppErrorContext(
                    source: .network,
                    screen: .words,
                    metadata: ["url": "https://api.example.com"],
                    severity: .error
                ),
                title: "Network Error",
                message: "Unable to connect to server. Please check your internet connection.",
                actionTitle: "Retry",
                action: {}
            )
        ) {
            VStack(spacing: 20) {
                Text("Content Example")
                    .foregroundColor(ThemeManager.shared.currentThemeStyle.textPrimary)
                .foregroundColor(ThemeManager.shared.currentThemeStyle.accentPrimary)
            }
            .padding()
        }
    }
}
