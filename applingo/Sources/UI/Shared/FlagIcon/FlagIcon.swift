import SwiftUI
import FlagKit

struct FlagIcon: View {
    let code: String
    let style: FlagIconStyle
    
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

    private func flagCell(code: String) -> some View {
        let countryCode = convertToCountryCode(code.lowercased())

        return Group {
            if let flag = Flag(countryCode: countryCode) {
                Image(uiImage: flag.image(style: .circle))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: style.flagSize, height: style.flagSize)
                    .overlay(
                        Group {
                            AnyView(
                                Circle()
                                    .stroke(style.borderColor, lineWidth: 1)
                            )
                        }
                    )
            } else {
                Text(code.uppercased())
                    .font(.system(size: style.codeSize, weight: .medium))
                    .foregroundColor(style.codeColor)
                    .frame(width: style.flagSize, height: style.flagSize)
                    .background(style.fallbackBackgroundColor)
                    .clipShape(AnyShape(Circle()))
            }
        }
        .shadow(color: style.shadowColor.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    private func convertToCountryCode(_ languageCode: String) -> String {
        switch languageCode.lowercased() {
        case "en": return "GB"
        case "us": return "US"
        case "ru": return "RU"
        case "de": return "DE"
        case "fr": return "FR"
        case "es": return "ES"
        case "it": return "IT"
        case "pt": return "PT"
        case "br": return "BR"
        case "ja": return "JP"
        case "ko": return "KR"
        case "zh": return "CN"
        case "tw": return "TW"
        case "nl": return "NL"
        case "sv": return "SE"
        case "fi": return "FI"
        case "no": return "NO"
        case "da": return "DK"
        case "pl": return "PL"
        case "cs": return "CZ"
        case "sk": return "SK"
        case "hu": return "HU"
        case "tr": return "TR"
        case "ar": return "SA"
        case "he": return "IL"
        case "uk": return "UA"
        case "ro": return "RO"
        case "bg": return "BG"
        case "sr": return "RS"
        case "hr": return "HR"
        case "el": return "GR"
        case "vi": return "VN"
        case "id": return "ID"
        case "th": return "TH"
        case "ms": return "MY"
        case "hi": return "IN"
        case "bn": return "BD"
        case "ta": return "LK"
        case "fa": return "IR"
        case "ur": return "PK"
        case "ph": return "PH"
        case "my": return "MY"
        case "sg": return "SG"
        case "ae": return "AE"
        case "eg": return "EG"
        case "dz": return "DZ"
        case "ma": return "MA"
        case "tn": return "TN"
        case "za": return "ZA"
        case "ng": return "NG"
        case "ke": return "KE"
        case "gh": return "GH"
        case "zm": return "ZM"
        case "ci": return "CI"
        case "ml": return "ML"
        case "sn": return "SN"
        case "et": return "ET"
        case "tz": return "TZ"
        case "ug": return "UG"
        case "cm": return "CM"
        case "bd": return "BD"
        case "pk": return "PK"
        case "lk": return "LK"
        case "np": return "NP"
        case "bt": return "BT"
        case "kh": return "KH"
        case "la": return "LA"
        case "mm": return "MM"
        case "mn": return "MN"
        case "uz": return "UZ"
        case "az": return "AZ"
        case "kz": return "KZ"
        case "kg": return "KG"
        case "tm": return "TM"
        case "ge": return "GE"
        case "am": return "AM"
        case "ee": return "EE"
        case "lv": return "LV"
        case "lt": return "LT"
        case "md": return "MD"
        case "by": return "BY"
        case "ba": return "BA"
        case "me": return "ME"
        case "mk": return "MK"
        case "al": return "AL"
        case "mt": return "MT"
        case "cy": return "CY"
        case "is": return "IS"
        case "ie": return "IE"
        case "ch": return "CH"
        case "lu": return "LU"
        case "be": return "BE"
        case "li": return "LI"
        case "mc": return "MC"
        case "ad": return "AD"
        case "sm": return "SM"
        case "va": return "VA"
        case "gi": return "GI"
        case "bb": return "BB"
        case "jm": return "JM"
        case "tt": return "TT"
        case "bz": return "BZ"
        case "cr": return "CR"
        case "cu": return "CU"
        case "do": return "DO"
        case "gt": return "GT"
        case "hn": return "HN"
        case "ni": return "NI"
        case "pa": return "PA"
        case "ve": return "VE"
        case "uy": return "UY"
        case "bo": return "BO"
        case "py": return "PY"
        case "ec": return "EC"
        case "pe": return "PE"
        case "cl": return "CL"
        case "gy": return "GY"
        case "gf": return "GF"
        case "fk": return "FK"
        default: return languageCode.uppercased()
        }
    }
}
