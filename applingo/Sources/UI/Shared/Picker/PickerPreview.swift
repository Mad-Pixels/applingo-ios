import SwiftUI

struct PickerPreview: View {
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
        }
    }
    
    private func previewSection(_ title: String, theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
            
            AppPicker(
                selectedValue: $selectedWheel,
                items: PreviewItem.allCases,
                title: "Wheel Style",
                style: .themed(theme, type: .wheel)
            ) { item in
                Text(item.localizedTitle)
            }
            
            AppPicker(
                selectedValue: $selectedSegmented,
                items: PreviewItem.allCases,
                title: "Segmented Style",
                style: .themed(theme, type: .segmented)
            ) { item in
                Text(item.localizedTitle)
            }
            
            AppPicker(
                selectedValue: $selectedMenu,
                items: PreviewItem.allCases,
                title: "Menu Style",
                style: .themed(theme, type: .menu)
            ) { item in
                Text(item.localizedTitle)
            }
            
            AppPicker(
                selectedValue: $selectedInline,
                items: PreviewItem.allCases,
                title: "Inline Style",
                style: .themed(theme, type: .inline)
            ) { item in
                Text(item.localizedTitle)
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}

#Preview("Picker Styles") {
    PickerPreview()
}
