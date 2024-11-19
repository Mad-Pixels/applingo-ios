import SwiftUI

struct CompDictionaryInstructionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isShowingFileImporter: Bool
    let onClose: () -> Void
    let theme = ThemeManager.shared.currentThemeStyle
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 60))
                        .foregroundColor(theme.accentColor)
                        .padding(.top, 20)
                    
                    VStack(spacing: 24) {
                        instructionSection(
                            title: "CSV File Format",
                            icon: "list.bullet.rectangle.fill",
                            content: [
                                "File must be in CSV format with UTF-8 encoding",
                                "First row should contain column headers",
                                "Required columns: front_text, back_text",
                                "Optional column: hint"
                            ]
                        )
                        
                        instructionSection(
                            title: "Example Format",
                            icon: "text.alignleft",
                            content: [
                                "front_text,back_text,hint",
                                "hello,привет,greeting word",
                                "world,мир,planet earth",
                                "good morning,доброе утро,morning greeting"
                            ]
                        )
                        
                        instructionSection(
                            title: "Important Notes",
                            icon: "exclamationmark.triangle.fill",
                            content: [
                                "Maximum file size: 10MB",
                                "Maximum 5000 words per dictionary",
                                "Text fields should not contain commas",
                                "Empty lines will be skipped"
                            ]
                        )
                    }
                    .padding()
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isShowingFileImporter = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.down.fill")
                                Text(LanguageManager.shared.localizedString(for: "ImportCSV"))
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(theme.accentColor)
                            .cornerRadius(12)
                        }
                                        
                        Button(action: onClose) {
                            Text(LanguageManager.shared.localizedString(for: "Close"))
                                .font(.headline)
                                .foregroundColor(theme.secondaryTextColor)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(theme.backgroundViewColor.edgesIgnoringSafeArea(.all))
            .navigationTitle(LanguageManager.shared.localizedString(for: "ImportInstructions"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func instructionSection(title: String, icon: String, content: [String]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(theme.accentColor)
                Text(LanguageManager.shared.localizedString(for: title))
                    .font(.headline)
                    .foregroundColor(theme.baseTextColor)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(content, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(theme.secondaryTextColor)
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)
                        
                        Text(LanguageManager.shared.localizedString(for: item))
                            .font(.subheadline)
                            .foregroundColor(theme.secondaryTextColor)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.backgroundBlockColor)
                .shadow(
                    color: theme.accentColor.opacity(0.1),
                    radius: 10,
                    x: 0,
                    y: 5
                )
        )
    }
}
