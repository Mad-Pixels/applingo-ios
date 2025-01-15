import SwiftUI
import IQKeyboardManagerSwift

/// Наблюдатель за изменением фрейма клавиатуры и её анимационных параметров
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
        
        // Извлекаем анимационные параметры, чтобы «синхронизироваться» с клавиатурой
        if let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            animationDuration = duration
        }
        if let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
           let curve = UIView.AnimationCurve(rawValue: curveRaw) {
            animationCurve = curve
        }
        
        // Проверяем, закрыта ли клавиатура (высота = 0) или открыта (высота > 0)
        if endFrame.origin.y >= UIScreen.main.bounds.height {
            height = 0
        } else {
            height = endFrame.height
        }
    }
}

/// Модификатор для отображения кастомного тулбара поверх экрана
struct CustomKeyboardToolbarModifier: ViewModifier {
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    let enableIQKeyboard: Bool
    let resignOnTouchOutside: Bool
    let buttonTitle: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
                .onAppear {
                    // Настраиваем IQKeyboardManager
                    IQKeyboardManager.shared.enable = enableIQKeyboard
                    IQKeyboardManager.shared.resignOnTouchOutside = resignOnTouchOutside
                    // Отключаем встроенный тулбар, чтобы не дублировался наш
                    IQKeyboardManager.shared.enableAutoToolbar = false
                }
            
            // Когда клавиатура высотой > 0, показываем нашу кнопку
            if keyboardObserver.height > 0 {
                VStack(spacing: 0) {
                    Button {
                        // Прячем клавиатуру
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                        )
                    } label: {
                        Text(buttonTitle)
                            .font(.system(size: 16, weight: .semibold))
                            // Высота кнопки 36 (можно выбрать любую)
                            .frame(height: 36)
                            // Растягиваем по всей ширине экрана
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                    }
                    // Расстояние между кнопкой и верхом клавиатуры (необязательно)
                    //.padding(.bottom, 4)
                }
                // Располагаем кнопку над клавиатурой (учитывая высоту)
                .padding(.bottom, keyboardObserver.height)
                // Синхронизируем анимацию с клавиатурой
                .animation(
                    .interactiveSpring(
                        response: keyboardObserver.animationDuration,
                        dampingFraction: 1.0,
                        blendDuration: 0
                    ),
                    value: keyboardObserver.height
                )
            }
        }
        // Игнорируем безопасную зону снизу, чтобы кнопка была ровно над клавиатурой
        .edgesIgnoringSafeArea(.bottom)
    }
}

/// Удобный экстеншн для использования модификатора
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
