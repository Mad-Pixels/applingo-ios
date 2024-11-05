import Foundation
import Combine

final class CategoryRemoteGetterViewModel: BaseApiViewModel {
    @Published var frontCategories: [CategoryItem] = []
    @Published var backCategories: [CategoryItem] = []
    @Published var isLoadingPage = false
    
    private var frame: AppFrameModel = .main
    private let repository: APIRepositoryProtocol
    
    init(repository: APIRepositoryProtocol) {
        self.repository = repository
    }
    
    func get(completion: @escaping (Result<Void, Error>) -> Void) {
        self.isLoadingPage = true
        
        performApiOperation(
            {
                return try await self.repository.getCategories()
            },
            successHandler: { [weak self] (categoryItemModel: CategoryItemModel) in
                guard let self = self else { return }
                self.frontCategories = categoryItemModel.frontCategory
                self.backCategories = categoryItemModel.backCategory
                ErrorManager.shared.clearError(for: .categoriesGet)
            },
            source: .categoriesGet,
            frame: frame,
            message: "Failed to fetch categories from api request",
            additionalInfo: ["function": "getCategories"],
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
