import Foundation
import AVFoundation

/// Сервис для преобразования текста в речь
class TTS {
    /// Общий экземпляр сервиса (синглтон)
    static let shared = TTS()
    
    /// Синтезатор речи
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    /// Инициализатор
    private init() {
        setupAudioSession()
    }
    
    /// Настройка аудио сессии
    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("TTS: Ошибка настройки аудио сессии: \(error)")
        }
    }
    
    /// Озвучивает текст на указанном языке
    /// - Parameters:
    ///   - text: Текст для озвучивания
    ///   - language: Код языка (например, "en-US", "ru-RU", "he-IL")
    ///   - rate: Скорость речи (от 0.0 до 1.0, по умолчанию 0.5)
    ///   - pitch: Высота голоса (от 0.5 до 2.0, по умолчанию 1.0)
    ///   - completion: Опциональное замыкание, вызываемое по завершении озвучивания
    func speak(
        _ text: String,
        language: String,
        rate: Float = 0.5,
        pitch: Float = 1.0,
        completion: (() -> Void)? = nil
    ) {
        guard !text.isEmpty else {
            print("TTS: Пустой текст, озвучивание не требуется")
            completion?()
            return
        }
        
        // Создаем объект для озвучивания
        let utterance = AVSpeechUtterance(string: text)
        
        // Устанавливаем голос для указанного языка
        if let voice = AVSpeechSynthesisVoice(language: language) {
            utterance.voice = voice
        } else {
            print("TTS: Голос для языка \(language) не найден, используем системный по умолчанию")
        }
        
        // Настраиваем параметры озвучивания
        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        utterance.volume = 1.0
        
        // Останавливаем предыдущее озвучивание
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        // Добавляем делегат для отслеживания завершения, если требуется
        if let completion = completion {
            let delegate = TTSDelegate(completion: completion)
            utterance.setValue(delegate, forKey: "delegate")
        }
        
        // Запускаем озвучивание на главном потоке
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.speechSynthesizer.speak(utterance)
            print("TTS: Начато озвучивание текста: \(text) на языке: \(language)")
        }
    }
    
    /// Останавливает текущее озвучивание
    func stop() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
            print("TTS: Озвучивание остановлено")
        }
    }
    
    /// Возвращает список доступных языков
    /// - Returns: Массив строк с кодами доступных языков
    func availableLanguages() -> [String] {
        return AVSpeechSynthesisVoice.speechVoices().map { $0.language }
    }
}

/// Вспомогательный класс для отслеживания завершения озвучивания
private class TTSDelegate: NSObject, AVSpeechSynthesizerDelegate {
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
        super.init()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        completion()
    }
}
