import Foundation
import Combine

final class CategoryFetcher: ProcessApi {
    @Published var frontCategories: [CategoryItem] = []
    @Published var backCategories: [CategoryItem] = []
    @Published var isLoadingPage = false

    private let repository: ApiManagerRequest
    private let screenType: ScreenType = .dictionariesRemoteFilter

    init(repository: ApiManagerRequest = ApiManagerRequest()) {
        self.repository = repository
        super.init()
    }

    func get(forceFetch: Bool = false, completion: @escaping (Result<Void, Error>) -> Void) {
        isLoadingPage = true
        
        if forceFetch {
            ApiManagerCache.shared.clearCache()
        }

        // Вызываем упрощённый метод performApiOperation(...)
        performApiOperation(
            {
                try await self.repository.getCategories()
            },
            success: { [weak self] (categoryItemModel: CategoryItemModel) in
                guard let self = self else { return }
                
                self.frontCategories = categoryItemModel.frontCategory
                self.backCategories = categoryItemModel.backCategory
                
                // Если нужен сброс ошибки в новом ErrorManager — используйте
                // ErrorManager.shared.clearError(screen: self.screenType)
                
                Logger.debug("[CategoryRemoteGetterViewModel] Fetched: front(\(categoryItemModel.frontCategory.count)), back(\(categoryItemModel.backCategory.count))")
            },
            screen: screenType,
            metadata: [
                "operation": "getCategories",
                "forceFetch": "\(forceFetch)"
            ],
            completion: { [weak self] result in
                self?.isLoadingPage = false
                completion(result)
            }
        )
    }

    func clear() {
        frontCategories.removeAll()
        backCategories.removeAll()
    }
}
