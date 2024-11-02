import Foundation
import Combine

final class DictionaryRemoteFilterViewModel: ObservableObject {
    @Published var frontCategories: [CategoryItem] = []
    @Published var backCategories: [CategoryItem] = []
    
    private var cancellable: AnyCancellable?
    private var frame: AppFrameModel = .main

    init() {
        Logger.debug("[DictionaryRemoteFilterViewModel]: ViewModel initialized")
    }

    deinit {
        cancellable?.cancel()
    }

    // Метод для получения списка категорий с 10% шансом возврата ошибки
    func getCategories() {
        Logger.debug("[DictionaryRemoteFilterViewModel]: Fetching categories...")

        // 10% шанс вернуть ошибку
        if Int.random(in: 1...10) <= 1 {
            Logger.debug("[DictionaryRemoteFilterViewModel]: Failed to fetch categories")

            // Очищаем текущие данные
            self.frontCategories = []
            self.backCategories = []

            let error = AppErrorModel(
                errorType: .network,
                errorMessage: "Failed to fetch categories from the remote server",
                additionalInfo: nil
            )

            // Передаем ошибку в ErrorManager
            ErrorManager.shared.setError(
                appError: error,
                frame: frame,
                source: .categoriesGet
            )
            return
        }

        // Пример данных для front_text и back_text категорий
        let frontCategoryData: [CategoryItem] = [
            CategoryItem(name: "Language"),
            CategoryItem(name: "Technology"),
            CategoryItem(name: "Science")
        ]
        
        let backCategoryData: [CategoryItem] = [
            CategoryItem(name: "History"),
            CategoryItem(name: "Geography"),
            CategoryItem(name: "Culture")
        ]

        // Обновляем Published переменные
        self.frontCategories = frontCategoryData
        self.backCategories = backCategoryData

        // Очищаем ошибки при успешном получении данных
        ErrorManager.shared.clearError(for: .categoriesGet)
        Logger.debug("[DictionaryRemoteFilterViewModel]: Categories data successfully fetched")
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
}
