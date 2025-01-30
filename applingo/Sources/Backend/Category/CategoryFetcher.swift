import Foundation
import Combine

/// A class responsible for fetching category data from the API.
/// Handles loading and caching of front and back categories.
final class CategoryFetcher: ProcessApi {
    // MARK: - Public Properties
    
    @Published private(set) var frontCategories: [CategoryItem] = []
    @Published private(set) var backCategories: [CategoryItem] = []
    @Published private(set) var isLoadingPage = false
    
    // MARK: - Private Properties
    
    private let repository: ApiManagerRequest
    
    // MARK: - Initialization
    
    init(repository: ApiManagerRequest = ApiManagerRequest()) {
        self.repository = repository
        super.init()
        Logger.info("[Category]: Initialized CategoryFetcher")
    }
    
    // MARK: - Public Methods
        
    /// Fetches categories from the API
    /// - Parameters:
    ///   - forceFetch: Whether to clear cache before fetching
    ///   - completion: Called with the result of the operation
    func get(forceFetch: Bool = false, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isLoadingPage else {
            Logger.debug("[Category]: Skipping fetch - already loading")
            completion(.success(()))
            return
        }
        
        Logger.info(
            "[Category]: Starting categories fetch",
            metadata: ["forceFetch": String(forceFetch)]
        )
        
        isLoadingPage = true
        
        if forceFetch {
            Logger.debug("[Category]: Clearing cache before fetch")
            ApiManagerCache.shared.clearCache()
        }

        performApiOperation(
            { try await self.repository.getCategories() },
            success: { [weak self] (categoryItemModel: ApiModelCategoryItem) in
                guard let self = self else {
                    Logger.warning("[Category]: Self deallocated during fetch")
                    return
                }
                
                self.handleFetchSuccess(categoryItemModel)
            },
            screen: screen,
            metadata: [
                "operation": "getCategories",
                "forceFetch": String(forceFetch)
            ],
            completion: { [weak self] result in
                guard let self = self else { return }
                
                if case .failure(let error) = result {
                    Logger.error(
                        "[Category]: Categories fetch failed",
                        metadata: ["error": error.localizedDescription]
                    )
                } else {
                    Logger.info("[Category]: Categories fetch completed successfully")
                }
                
                self.isLoadingPage = false
                completion(result)
            }
        )
    }
    
    /// Clears all loaded categories
    func clear() {
        Logger.info(
            "[Category]: Clearing categories",
            metadata: [
                "frontCount": String(frontCategories.count),
                "backCount": String(backCategories.count)
            ]
        )
        
        frontCategories.removeAll()
        backCategories.removeAll()
    }
    
    // MARK: - Private Methods
    
    /// Handles successful category fetch
    private func handleFetchSuccess(_ categoryItemModel: ApiModelCategoryItem) {
        frontCategories = categoryItemModel.frontCategory
        backCategories = categoryItemModel.backCategory
        
        Logger.info(
            "[Category]: Categories updated",
            metadata: [
                "frontCount": String(categoryItemModel.frontCategory.count),
                "backCount": String(categoryItemModel.backCategory.count)
            ]
        )
    }
}
