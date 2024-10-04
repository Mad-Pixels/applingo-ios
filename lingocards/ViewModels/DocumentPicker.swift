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
            if let selectedURL = urls.first {
                // Обрабатываем выбранный файл и вызываем замыкание
                parent.selectedFileURL = selectedURL
                parent.onPick(selectedURL)
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Обработчик отмены выбора файла, если это необходимо
        }
    }
}
