import SwiftUI
import Combine

internal struct GameQuizViewAnswerRecord: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var recognizedText: String
    @State private var audioLevel: CGFloat = 0.0
    
    internal let languageCode: String

    var body: some View {
        VStack(spacing: 8) {
            SectionBody(content: {
                ZStack(alignment: .bottom) {
                    AudioLevelVisualizer(
                        level: audioLevel,
                        style: .themed(themeManager.currentThemeStyle)
                    )
                    .padding(.horizontal)

                    DynamicText(
                        model: DynamicTextModel(text: recognizedText.lowercased()),
                        style: .headerGame(
                            themeManager.currentThemeStyle,
                            alignment: .center,
                            lineLimit: 4
                        )
                    )
                    .frame(height: 220)
                }
            }, style: .accent(themeManager.currentThemeStyle))
            .padding(.vertical, 24)
            
            Spacer()
        }
        .onReceive(NotificationCenter.default.publisher(for: .ASRAudioLevelChanged)) { notification in
            if let level = notification.userInfo?["level"] as? Float {
                withAnimation(.linear(duration: 0.1)) {
                    audioLevel = CGFloat(level)
                }
            }
        }
        .onDisappear {
            recognizedText = ""
        }
        .frame(height: 328)
    }
}
