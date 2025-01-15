import SwiftUI
import IQKeyboardManagerSwift

final class KeyboardObserver: ObservableObject {
    @Published var height: CGFloat = 0
    @Published var animationDuration: Double = 0.25
    @Published var animationCurve: UIView.AnimationCurve = .easeInOut
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillChangeFrame),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        
        if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            animationDuration = duration
        }
        if let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
           let curve = UIView.AnimationCurve(rawValue: curveRaw) {
            animationCurve = curve
        }
        
        if endFrame.origin.y >= UIScreen.main.bounds.height {
            height = 0
        } else {
            height = endFrame.height
        }
    }
}

struct CustomKeyboardToolbarModifier: ViewModifier {
    @StateObject private var keyboardObserver = KeyboardObserver()
    @State private var showToolbar = false
    
    let enableIQKeyboard: Bool
    let resignOnTouchOutside: Bool
    let buttonTitle: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .onAppear {
                    IQKeyboardManager.shared.enable = enableIQKeyboard
                    IQKeyboardManager.shared.resignOnTouchOutside = resignOnTouchOutside
                    IQKeyboardManager.shared.enableAutoToolbar = false
                }
                .onChange(of: keyboardObserver.height) { newHeight in
                    if newHeight > 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showToolbar = true
                            }
                        }
                    } else {
                        withAnimation(.easeInOut(duration: keyboardObserver.animationDuration)) {
                            showToolbar = false
                        }
                    }
                }
            
            if showToolbar {
                VStack(spacing: 0) {
                    Button {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    } label: {
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                            .background(ThemeManager.shared.currentThemeStyle.accentPrimary)
                            .foregroundColor(ThemeManager.shared.currentThemeStyle.backgroundPrimary)
                    }
                }
                .padding(.bottom, keyboardObserver.height)
                .transition(.opacity)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension View {
    func customKeyboardToolbar(
        enableIQKeyboard: Bool = true,
        resignOnTouchOutside: Bool = true,
        buttonTitle: String = "Done"
    ) -> some View {
        self.modifier(CustomKeyboardToolbarModifier(
            enableIQKeyboard: enableIQKeyboard,
            resignOnTouchOutside: resignOnTouchOutside,
            buttonTitle: buttonTitle
        ))
    }
}
