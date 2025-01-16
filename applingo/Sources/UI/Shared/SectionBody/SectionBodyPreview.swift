import SwiftUI

struct SectionBodyPreview_Previews: PreviewProvider {
    static var previews: some View {
        SectionBodyPreview()
            .previewDisplayName("Section Body Components")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct SectionBodyPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                previewSection("Light Theme", theme: LightTheme())
                previewSection("Dark Theme", theme: DarkTheme())
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
    
    private func previewSection(_ title: String, theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
                .foregroundColor(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Default Section")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    SectionBody(style: .themed(theme)) {
                        Text("This is a default section body.")
                            .font(.body)
                            .foregroundColor(theme.textPrimary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Section with Custom Padding")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    SectionBody(style: SectionBodyStyle(
                        backgroundColor: theme.backgroundSecondary,
                        shadowColor: theme.accentPrimary,
                        cornerRadius: 16,
                        shadowRadius: 8,
                        padding: EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
                    )) {
                        VStack {
                            Text("Custom padding applied.")
                                .font(.body)
                                .foregroundColor(theme.textPrimary)
                            Text("Content is more spacious.")
                                .font(.footnote)
                                .foregroundColor(theme.textSecondary)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Section with Rounded Corners")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    SectionBody(style: SectionBodyStyle(
                        backgroundColor: theme.backgroundSecondary,
                        shadowColor: theme.accentPrimary,
                        cornerRadius: 24,
                        shadowRadius: 12,
                        padding: EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
                    )) {
                        Text("This section has extra rounded corners.")
                            .font(.body)
                            .foregroundColor(theme.textPrimary)
                    }
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}
