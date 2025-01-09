import SwiftUI

struct PickerPreview: View {
    enum PreviewItem: String, CaseIterable {
        case first = "First"
        case second = "Second"
        case third = "Third"
        
        var localizedTitle: String {
            switch self {
            case .first: return "First Option"
            case .second: return "Second Option"
            case .third: return "Third Option"
            }
        }
    }
    
    @State private var selectedWheel: PreviewItem = .first
    @State private var selectedSegmented: PreviewItem = .first
    @State private var selectedMenu: PreviewItem = .first
    @State private var selectedInline: PreviewItem = .first
    
    var body: some View {
        VStack(spacing: 20) {
            // Wheel Picker
            AppPicker(
                selectedValue: $selectedWheel,
                items: PreviewItem.allCases,
                title: "Wheel Style",
                style: .default
            ) { item in
                Text(item.localizedTitle)
            }
            
            // Segmented Picker
            AppPicker(
                selectedValue: $selectedSegmented,
                items: PreviewItem.allCases,
                title: "Segmented Style",
                style: .segmented
            ) { item in
                Text(item.localizedTitle)
            }
            
            // Menu Picker
            AppPicker(
                selectedValue: $selectedMenu,
                items: PreviewItem.allCases,
                title: "Menu Style",
                style: .menu
            ) { item in
                Text(item.localizedTitle)
            }
            
            // Inline Picker
            AppPicker(
                selectedValue: $selectedInline,
                items: PreviewItem.allCases,
                title: "Inline Style",
                style: .inline
            ) { item in
                Text(item.localizedTitle)
            }
        }
        .padding()
    }
}

#Preview("Picker Styles") {
    PickerPreview()
}

