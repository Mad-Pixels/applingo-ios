import SwiftUI

struct FlagIconPreview_Previews: PreviewProvider {
    static var previews: some View {
        FlagIconPreview()
            .previewDisplayName("Flag Icon Component (Light & Dark Mode)")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct FlagIconPreview: View {
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
                    Text(verbatim: "English to Russian")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)

                    FlagIcon(
                        code: "EN",
                        style: .themed(theme)
                    )
                    FlagIcon(
                        code: "RU",
                        style: .themed(theme)
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: "French to German")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)

                    FlagIcon(
                        code: "FR",
                        style: .themed(theme)
                    )
                    FlagIcon(
                        code: "DE",
                        style: .themed(theme)
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: "Spanish to Italian")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)

                    FlagIcon(
                        code: "ES",
                        style: .themed(theme)
                    )
                    FlagIcon(
                        code: "IT",
                        style: .themed(theme)
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: "Fallback Example (unknown country code)")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)

                    FlagIcon(
                        code: "XX",
                        style: .themed(theme)
                    )
                    FlagIcon(
                        code: "YY",
                        style: .themed(theme)
                    )
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
