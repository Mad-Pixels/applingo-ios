import Foundation
import AVFoundation

/// Сервис для преобразования текста в речь
class TTS {
    /// Общий экземпляр сервиса (синглтон)
    static let shared = TTS()
    
    /// Синтезатор речи
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    /// Словарь для преобразования кодов языков в полные коды локали
    private let languageMap: [String: String] = [
        "en": "en-US",
        "ru": "ru-RU",
        "he": "he-IL",
        "fr": "fr-FR",
        "de": "de-DE",
        "es": "es-ES",
        "it": "it-IT",
        "zh": "zh-CN",
        "ja": "ja-JP",
        "ko": "ko-KR",
        "ar": "ar-SA",
        "pt": "pt-BR",
        "nl": "nl-NL",
        "fi": "fi-FI",
        "sv": "sv-SE",
        "da": "da-DK",
        "no": "no-NO",
        "pl": "pl-PL",
        "tr": "tr-TR",
        "cs": "cs-CZ",
        "hu": "hu-HU",
        "el": "el-GR",
        "hi": "hi-IN",
        "th": "th-TH",
        "id": "id-ID"
    ]
    
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
    
    /// Преобразует код языка из формата "ru-en" в формат локали "en-US"
    /// - Parameter languageCode: Код языковой пары (например, "ru-en")
    /// - Returns: Полный код локали для TTS (например, "en-US")
    func getFullLanguageCode(from languageCode: String) -> String {
        // Проверяем, содержит ли код разделитель "-"
        if languageCode.contains("-") {
            // Это составной код (например, "ru-he")
            let parts = languageCode.split(separator: "-")
            
            guard parts.count >= 2, let targetLanguage = parts.last else {
                print("TTS: Неверный формат языкового кода: \(languageCode), используем en-US")
                return "en-US"
            }
            
            // Извлекаем код целевого языка (второй элемент)
            let shortCode = String(targetLanguage)
            
            // Преобразуем в полный код локали
            if let fullCode = languageMap[shortCode] {
                return fullCode
            } else {
                print("TTS: Неизвестный код языка: \(shortCode), пробуем создать стандартный формат")
                return "\(shortCode)-\(shortCode.uppercased())"
            }
        } else {
            // Это простой код (например, "he")
            if let fullCode = languageMap[languageCode] {
                print("TTS: Преобразован код \(languageCode) в \(fullCode)")
                return fullCode
            } else {
                print("TTS: Неизвестный код языка: \(languageCode), пробуем создать стандартный формат")
                return "\(languageCode)-\(languageCode.uppercased())"
            }
        }
    }
    
    /// Озвучивает текст на указанном языке
    /// - Parameters:
    ///   - text: Текст для озвучивания
    ///   - languageCode: Код языковой пары (например, "ru-en")
    ///   - rate: Скорость речи (от 0.0 до 1.0, по умолчанию 0.5)
    ///   - pitch: Высота голоса (от 0.5 до 2.0, по умолчанию 1.0)
    ///   - completion: Опциональное замыкание, вызываемое по завершении озвучивания
    func speak(
        _ text: String,
        languageCode: String,
        rate: Float = 0.5,
        pitch: Float = 1.0,
        completion: (() -> Void)? = nil
    ) {
        // Получаем полный код локали
        let fullLanguageCode = getFullLanguageCode(from: languageCode)
        
        // Вызываем основной метод с полным кодом локали
        speakWithFullCode(text, fullLanguageCode: fullLanguageCode, rate: rate, pitch: pitch, completion: completion)
    }
    
    /// Озвучивает текст на указанном языке с полным кодом локали
    /// - Parameters:
    ///   - text: Текст для озвучивания
    ///   - fullLanguageCode: Полный код локали (например, "en-US")
    ///   - rate: Скорость речи (от 0.0 до 1.0)
    ///   - pitch: Высота голоса (от 0.5 до 2.0)
    ///   - completion: Опциональное замыкание, вызываемое по завершении озвучивания
    private func speakWithFullCode(
        _ text: String,
        fullLanguageCode: String,
        rate: Float,
        pitch: Float,
        completion: (() -> Void)?
    ) {
        guard !text.isEmpty else {
            print("TTS: Пустой текст, озвучивание не требуется")
            completion?()
            return
        }
        
        // Создаем объект для озвучивания
        let utterance = AVSpeechUtterance(string: text)
        
        // Устанавливаем голос для указанного языка
        if let voice = AVSpeechSynthesisVoice(language: fullLanguageCode) {
            utterance.voice = voice
            print("TTS: Найден голос для языка \(fullLanguageCode)")
        } else {
            print("TTS: Голос для языка \(fullLanguageCode) не найден, используем системный по умолчанию")
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
            print("TTS: Начато озвучивание текста: \(text) на языке: \(fullLanguageCode)")
        }
    }
    
    /// Озвучивает текст на указанном языке
    /// - Parameters:
    ///   - text: Текст для озвучивания
    ///   - language: Полный код локали (например, "en-US")
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
        speakWithFullCode(text, fullLanguageCode: language, rate: rate, pitch: pitch, completion: completion)
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
