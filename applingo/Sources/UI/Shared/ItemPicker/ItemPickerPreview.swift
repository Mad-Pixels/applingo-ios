import SwiftUI

struct PickerPreview_Previews: PreviewProvider {
    static var previews: some View {
        PickerPreview()
            .previewDisplayName("Picker Styles")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct PickerPreview: View {
    enum PreviewItem: String, CaseIterable {
        case first = "First"
        case second = "Second"
        case third = "Third"
        
        var localizedTitle: String {
            rawValue
        }
    }
    
    @State private var selectedWheel: PreviewItem = .first
    @State private var selectedSegmented: PreviewItem = .first
    @State private var selectedMenu: PreviewItem = .first
    @State private var selectedInline: PreviewItem = .first
    
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
                    Text("Wheel Style")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemPicker(
                        selectedValue: $selectedWheel,
                        items: PreviewItem.allCases,
                        title: "",
                        style: .themed(theme, type: .wheel)
                    ) { item in
                        Text(item.localizedTitle)
                            .foregroundColor(theme.textPrimary)
                    }
                }
                .padding()
                .background(theme.backgroundSecondary)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Segmented Style")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemPicker(
                        selectedValue: $selectedSegmented,
                        items: PreviewItem.allCases,
                        title: "",
                        style: .themed(theme, type: .segmented)
                    ) { item in
                        Text(item.localizedTitle)
                            .foregroundColor(theme.textPrimary)
                    }
                }
                .padding()
                .background(theme.backgroundSecondary)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Menu Style")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemPicker(
                        selectedValue: $selectedMenu,
                        items: PreviewItem.allCases,
                        title: "",
                        style: .themed(theme, type: .menu)
                    ) { item in
                        Text(item.localizedTitle)
                            .foregroundColor(theme.textPrimary)
                    }
                }
                .padding()
                .background(theme.backgroundSecondary)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Inline Style")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemPicker(
                        selectedValue: $selectedInline,
                        items: PreviewItem.allCases,
                        title: "",
                        style: .themed(theme, type: .inline)
                    ) { item in
                        Text(item.localizedTitle)
                            .foregroundColor(theme.textPrimary)
                    }
                }
                .padding()
                .background(theme.backgroundSecondary)
                .cornerRadius(12)
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
