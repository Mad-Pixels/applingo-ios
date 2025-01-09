import SwiftUI

struct TogglePreview: View {
    @State private var isOnWithHeader = false
    @State private var isOnWithoutHeader = false
    
    var body: some View {
        VStack(spacing: 20) {
            AppToggle(
                isOn: $isOnWithHeader,
                title: "send_errors_logs",
                header: "log_settings",
                style: .default,
                onChange: { newValue in
                    print("Toggle changed to: \(newValue)")
                }
            )
            
            AppToggle(
                isOn: $isOnWithoutHeader,
                title: "enable_notifications",
                style: .compact,
                onChange: { newValue in
                    print("Toggle changed to: \(newValue)")
                }
            )
        }
        .padding()
    }
}

#Preview("Toggle Styles") {
    TogglePreview()
}
