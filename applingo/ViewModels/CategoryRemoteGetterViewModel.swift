import Foundation
import Combine

final class CategoryRemoteGetterViewModel: BaseApiViewModel {
    @Published var frontCategories: [CategoryItem] = []
    @Published var backCategories: [CategoryItem] = []
    @Published var isLoadingPage = false
    
    private var frame: AppFrameModel = .main
    private let repository: ApiRepositoryProtocol
    
    init(repository: ApiRepositoryProtocol = RepositoryCache.shared) {
        self.repository = repository
        super.init()
    }
    
    func get(forceFetch: Bool = false, completion: @escaping (Result<Void, Error>) -> Void) {
        self.isLoadingPage = true
        
        if forceFetch {
            (repository as? RepositoryCache)?.clearCache()
        }
        performApiOperation(
            {
                return try await self.repository.getCategories()
            },
            successHandler: { [weak self] (categoryItemModel: CategoryItemModel) in
                guard let self = self else { return }
                self.frontCategories = categoryItemModel.frontCategory
                self.backCategories = categoryItemModel.backCategory
                ErrorManager1.shared.clearError(for: .categoriesGet)
                Logger.debug("[CategoryRemoteGetterViewModel]: Categories updated - front: \(categoryItemModel.frontCategory.count), back: \(categoryItemModel.backCategory.count)")
            },
            source: .categoriesGet,
            frame: frame,
            message: "Failed to fetch categories from api request",
            additionalInfo: [
                "function": "getCategories",
                "forceFetch": "\(forceFetch)"
            ],
            completion: { [weak self] result in
                self?.isLoadingPage = false
                completion(result)
            }
        )
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
    
    func clear() {
        frontCategories = []
        backCategories = []
    }
}
