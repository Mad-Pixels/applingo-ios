import SwiftUI
import UIKit

// Представление для выбора документа
struct DocumentPicker: UIViewControllerRepresentable {
    // Свойство для хранения выбранного URL файла
    @Binding var selectedFileURL: URL?
    var onPick: (URL) -> Void // Замыкание для обработки выбранного файла

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // Конфигурируем UIDocumentPickerViewController для выбора CSV файлов
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker

        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            
            parent.selectedFileURL = url
            
            // Логируем выбор файла
            print("DocumentPicker: Selected file URL: \(url)")
            //parent.parent.appState.logger.log("DocumentPicker: Selected file URL: \(url)", level: .info, details: nil)
            
            parent.onPick(url)  // Передаем URL дальше
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            print("DocumentPicker: Selection cancelled") // Логируем отмену выбора
        }
    }
}
