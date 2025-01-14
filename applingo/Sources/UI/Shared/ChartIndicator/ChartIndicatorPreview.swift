// Shared/ChartIndicator/ChartIndicator+Preview.swift
import SwiftUI

struct ChartIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ChartIndicatorPreview()
            .previewDisplayName("Chart Indicator Component")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct ChartIndicatorPreview: View {
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
                // Low progress
                VStack(alignment: .leading, spacing: 8) {
                    Text("Low progress")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ChartIndicator(
                        weight: 250,
                        style: .themed(theme)
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.backgroundSecondary)
                    .cornerRadius(12)
                }
                
                // Medium progress
                VStack(alignment: .leading, spacing: 8) {
                    Text("Medium progress")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ChartIndicator(
                        weight: 500,
                        style: .themed(theme)
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.backgroundSecondary)
                    .cornerRadius(12)
                }
                
                // High progress
                VStack(alignment: .leading, spacing: 8) {
                    Text("High progress")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ChartIndicator(
                        weight: 850,
                        style: .themed(theme)
                    )
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.backgroundSecondary)
                    .cornerRadius(12)
                }
                
                // Animated example
                VStack(alignment: .leading, spacing: 8) {
                    Text("Animated example")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    AnimatedExample(theme: theme)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.backgroundSecondary)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

private struct AnimatedExample: View {
    let theme: AppTheme
    @State private var weight = 500
    
    var body: some View {
        VStack(spacing: 16) {
            ChartIndicator(
                weight: weight,
                style: .themed(theme)
            )
            
            Button("Randomize") {
                withAnimation {
                    weight = Int.random(in: 0...1000)
                }
            }
            .foregroundColor(theme.accentPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(theme.accentPrimary.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
