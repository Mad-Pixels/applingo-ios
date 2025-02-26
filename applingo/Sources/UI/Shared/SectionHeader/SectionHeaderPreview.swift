import SwiftUI

struct SectionHeaderPreview_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderPreview()
            .previewDisplayName("Section Header Components")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct SectionHeaderPreview: View {
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
                    Text(verbatim: "Default Header")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    SectionHeader(
                        title: "Default Section Header",
                        style: .themed(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: "Titled Header")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    SectionHeader(
                        title: "Default Section Header",
                        style: .titled(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: "Custom Font & Colors")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    SectionHeader(
                        title: "Custom Styled Header",
                        style: SectionHeaderStyle(
                            titleColor: theme.accentPrimary,
                            separatorColor: theme.textPrimary.opacity(0.25),
                            titleFont: .system(size: 16, weight: .bold),
                            spacing: 12,
                            padding: EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
                        )
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: "Minimal Header")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    SectionHeader(
                        title: "Minimalistic Header",
                        style: SectionHeaderStyle(
                            titleColor: theme.textPrimary,
                            separatorColor: .clear,
                            titleFont: .system(size: 12, weight: .regular),
                            spacing: 4,
                            padding: EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                        )
                    )
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}
