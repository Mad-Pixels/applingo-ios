import SwiftUI
import FlagKit

struct FlagIcon: View {
    let code: String
    let style: FlagIconStyle

    /// Initializes the FlagIcon.
    /// - Parameters:
    ///   - code: The language or country code.
    ///   - style: The style to apply. Defaults to themed style using the current theme.
    init(
        code: String,
        style: FlagIconStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.code = code
        self.style = style
    }

    var body: some View {
        HStack(spacing: style.spacing) {
            flagCell(code: code)
        }
    }

    /// Returns a view containing the flag image or a fallback text if no flag is found.
    private func flagCell(code: String) -> some View {
        let countryCode = convertToCountryCode(code.lowercased())
        
        return Group {
            if let flag = Flag(countryCode: countryCode) {
                Image(uiImage: flag.image(style: .circle))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: style.flagSize, height: style.flagSize)
                    .overlay(
                        Circle()
                            .stroke(style.borderColor, lineWidth: 1)
                    )
            } else {
                Text(code.uppercased())
                    .font(.system(size: style.codeSize, weight: .medium))
                    .foregroundColor(style.codeColor)
                    .frame(width: style.flagSize, height: style.flagSize)
                    .background(style.fallbackBackgroundColor)
                    .clipShape(Circle())
            }
        }
        .shadow(color: style.shadowColor.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    /// Converts a given language code to a country code.
    /// - Parameter languageCode: The input language code.
    /// - Returns: The corresponding country code.
    private func convertToCountryCode(_ languageCode: String) -> String {
        switch languageCode.lowercased() {
        case "en": return "GB"
        case "pt": return "PT"
        case "ja": return "JP"
        case "ko": return "KR"
        case "zh": return "CN"
        case "nl": return "NL"
        case "sv": return "SE"
        case "da": return "DK"
        case "ar": return "SA"
        case "he": return "IL"
        case "uk": return "UA"
        case "sr": return "RS"
        case "el": return "GR"
        case "vi": return "VN"
        case "ms": return "MY"
        case "hi": return "IN"
        case "ta": return "LK"
        case "fa": return "IR"
        case "ur": return "PK"
        default: return languageCode.uppercased()
        }
    }
}
