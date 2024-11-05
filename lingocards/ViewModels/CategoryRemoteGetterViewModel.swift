import Foundation
import Combine

final class CategoryRemoteGetterViewModel: ObservableObject {
    @Published var frontCategories: [CategoryItemModel] = []
    @Published var backCategories: [CategoryItemModel] = []
    
    private var cancellable: AnyCancellable?
    private var frame: AppFrameModel = .main

    init() {
        Logger.debug("[DictionaryRemoteFilterViewModel]: ViewModel initialized")
    }

    deinit {
        cancellable?.cancel()
    }

    func get() {
        Logger.debug("[DictionaryRemoteFilterViewModel]: Fetching categories...")

        // Симулируем случайную ошибку в 10% случаев
        if Int.random(in: 1...10) <= 1 {
            Logger.debug("[DictionaryRemoteFilterViewModel]: Failed to fetch categories")

            self.frontCategories = []
            self.backCategories = []

            let error = AppErrorModel(
                type: .network,
                message: "Failed to fetch categories from the remote server",
                localized: LanguageManager.shared.localizedString(for: "ErrFetchCategories").capitalizedFirstLetter,
                original: nil,
                additional: ["function": "getCategories"]
            )

            ErrorManager.shared.setError(
                appError: error,
                frame: frame,
                source: .categoriesGet
            )
            return
        }

        // Данные категорий, если ошибка не возникла
        let frontCategoryData: [CategoryItemModel] = [
            CategoryItemModel(name: "Language"),
            CategoryItemModel(name: "Technology"),
            CategoryItemModel(name: "Science")
        ]
        
        let backCategoryData: [CategoryItemModel] = [
            CategoryItemModel(name: "History"),
            CategoryItemModel(name: "Geography"),
            CategoryItemModel(name: "Culture")
        ]

        self.frontCategories = frontCategoryData
        self.backCategories = backCategoryData

        ErrorManager.shared.clearError(for: .categoriesGet)
        Logger.debug("[DictionaryRemoteFilterViewModel]: Categories data successfully fetched")
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
}
