import SwiftUI

struct CompDictionaryInstructionView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isShowingFileImporter: Bool
    let onClose: () -> Void
    let theme = ThemeManager.shared.currentThemeStyle

    var body: some View {
        NavigationView {
            List {
                Section(
                    header: Text(LanguageManager.shared.localizedString(for: "ImportNoteColumns").uppercased())
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(0..<4) { index in
                            let isRequired = index < 2
                            HStack(spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.system(.footnote, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(isRequired ? theme.accentColor : theme.secondaryTextColor)
                                    .frame(width: 24, height: 24)
                                    .background(
                                        Circle()
                                            .fill(isRequired ? theme.accentColor.opacity(0.15) : theme.secondaryTextColor.opacity(0.1))
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text([
                                        LanguageManager.shared.localizedString(for: "ImportNoteColumnFrontText").capitalizedFirstLetter,
                                        LanguageManager.shared.localizedString(for: "ImportNoteColumnBackText").capitalizedFirstLetter,
                                        LanguageManager.shared.localizedString(for: "ImportNoteColumnHintText").capitalizedFirstLetter,
                                        LanguageManager.shared.localizedString(for: "ImportNoteColumnDescriptionText").capitalizedFirstLetter
                                    ][index])
                                    .foregroundColor(theme.baseTextColor)
                                    
                                    Text(isRequired ?
                                         LanguageManager.shared.localizedString(for: "ImportNoteRequired").capitalizedFirstLetter
                                         : LanguageManager.shared.localizedString(for: "ImportNoteNotRequired").capitalizedFirstLetter)
                                        .font(.caption2)
                                        .foregroundColor(isRequired ? theme.accentColor : theme.secondaryTextColor)
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(theme.backgroundBlockColor)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Text(LanguageManager.shared.localizedString(for: "ImportNoteNoColumnsWarning").capitalizedFirstLetter)
                            .font(.footnote)
                            .foregroundColor(theme.errorTextColor)
                            .padding(.top, 4)
                            .padding(.leading, 4)
                    }
                }
                Section(
                    header: Text(LanguageManager.shared.localizedString(for: "ImportNoteExampleTitle").uppercased())
                ) {
                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(LanguageManager.shared.localizedString(for: "ImportNoteExampleCommaSeparated").uppercased())
                                    .font(.caption)
                                    .foregroundColor(theme.secondaryTextColor)
                                Text("cat,חתול,animal,household pet")
                                Text("cat,חתול,,household pet")
                                Text("cat,חתול,animal")
                            }
                            Divider()

                            VStack(alignment: .leading, spacing: 4) {
                                Text(LanguageManager.shared.localizedString(for: "ImportNoteExampleSemicolonsSeparated").uppercased())
                                    .font(.caption)
                                    .foregroundColor(theme.secondaryTextColor)
                                Text("sun;שמש;sky;the main star")
                                Text("sun;שמש;sky")
                                Text("sun;שמש;;the main star")
                            }
                            Divider()

                            VStack(alignment: .leading, spacing: 4) {
                                Text(LanguageManager.shared.localizedString(for: "ImportNoteExampleVerticalBarSeparated").uppercased())
                                    .font(.caption)
                                    .foregroundColor(theme.secondaryTextColor)
                                Text("sea|ים|water|large body of water")
                                Text("sea|ים||large body of water")
                                Text("sea|ים|water|")
                            }
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(LanguageManager.shared.localizedString(for: "ImportNoteExampleTabSeparated").uppercased())
                                    .font(.caption)
                                    .foregroundColor(theme.secondaryTextColor)
                            }
                        }
                        .font(.system(size: 14, design: .monospaced))
                    }
                    .padding(.vertical, 8)
                }
                .textSelection(.enabled)

                Section {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isShowingFileImporter = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.down.fill")
                            Text("ImportCSV")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.accentColor)
                        .cornerRadius(12)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: onClose) {
                            Text("Close")
                                .font(.headline)
                                .foregroundColor(theme.secondaryTextColor)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle(LanguageManager.shared.localizedString(for: "ImportNoteTitle").uppercased())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
