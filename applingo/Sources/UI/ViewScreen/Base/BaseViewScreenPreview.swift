import SwiftUI

/// Wrapper для корректного предпросмотра вьюх с поддержкой темы и ошибок
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

struct BaseViewScreenPreview<Content: View>: View {
    let style: BaseViewScreenStyle
    let content: Content
    let screen: ScreenType
    let theme: ThemeType
    let error: AppError?
   
    init(
        theme: ThemeType = .light,
        style: BaseViewScreenStyle = .default,
        screen: ScreenType,
        error: AppError? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.screen = screen
        self.error = error
        self.content = content()
        
        // Инициализируем состояния
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
        BaseViewScreenPreview(theme: .light, screen: .settings) {
            VStack(spacing: 20) {
                Text("Content Example")
                    .foregroundColor(ThemeManager.shared.currentThemeStyle.textPrimary)
                Button("Action Button") {
                    // action
                }
                .foregroundColor(ThemeManager.shared.currentThemeStyle.accentPrimary)
            }
            .padding()
        }
    }
}

#Preview("Dark Theme") {
    PreviewContainerView {
        BaseViewScreenPreview(theme: .dark, screen: .words) {
            VStack(spacing: 20) {
                Text("Content Example")
                    .foregroundColor(ThemeManager.shared.currentThemeStyle.textPrimary)
                Button("Action Button") {
                    // action
                }
                .foregroundColor(ThemeManager.shared.currentThemeStyle.accentPrimary)
            }
            .padding()
        }
    }
}

#Preview("Network Error") {
    PreviewContainerView {
        BaseViewScreenPreview(
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
                Button("Action Button") {
                    // action
                }
                .foregroundColor(ThemeManager.shared.currentThemeStyle.accentPrimary)
            }
            .padding()
        }
    }
}

#Preview("Validation Error") {
    PreviewContainerView {
        BaseViewScreenPreview(
            theme: .dark,
            screen: .wordsAdd,
            error: AppError(
                type: .validation(field: "word"),
                context: AppErrorContext(
                    source: .database,
                    screen: .wordsAdd,
                    metadata: [:],
                    severity: .warning
                ),
                title: "Validation Error",
                message: "Please enter a valid word",
                actionTitle: "OK",
                action: {}
            )
        ) {
            VStack(spacing: 20) {
                Text("Form Content")
                    .foregroundColor(ThemeManager.shared.currentThemeStyle.textPrimary)
                Button("Save") {
                    // action
                }
                .foregroundColor(ThemeManager.shared.currentThemeStyle.accentPrimary)
            }
            .padding()
        }
    }
}
