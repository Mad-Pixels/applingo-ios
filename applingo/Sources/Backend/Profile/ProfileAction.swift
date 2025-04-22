import Foundation
import Combine

/// A class responsible for managing profile-related API operations.
/// Handles creation and updating of user profiles.
final class ProfileAction: ProcessApi {
    @Published private(set) var isProcessing = false
        
    private let repository: ApiManagerRequest
    
    // MARK: - Initialization
    
    init(repository: ApiManagerRequest = ApiManagerRequest()) {
        self.repository = repository
        super.init()
        Logger.info("[Profile]: Initialized ProfileAction")
    }
    
    // MARK: - Public Methods
    
    /// Creates a new profile by sending a POST request to the API.
    /// - Parameters:
    ///   - id: The unique identifier for the profile.
    ///   - completion: Called with the result of the operation.
    func post(id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isProcessing else {
            Logger.debug("[Profile]: Skipping operation - already processing")
            completion(.success(()))
            return
        }
        
        isProcessing = true
        
        Logger.info(
            "[Profile]: Creating profile",
            metadata: ["id": id]
        )
        
        performApiOperation(
            { try await self.repository.createProfile(id: id) },
            success: { _ in
                Logger.info(
                    "[Profile]: Profile created successfully",
                    metadata: ["id": id]
                )
            },
            screen: .Home,
            metadata: [
                "operation": "createProfile",
                "id": id
            ],
            completion: { [weak self] result in
                guard let self = self else { return }

                self.isProcessing = false
                if case .failure(let error) = result,
                   let apiError = error as? APIError,
                   case .httpError(let statusCode) = apiError,
                   statusCode == 409 {
                    Logger.warning("[Profile]: Profile already exists (409), skipping")
                    completion(.success(()))
                } else {
                    completion(result)
                }
            }
        )
    }
    
    /// Updates an existing profile by sending a PATCH request to the API.
    /// - Parameters:
    ///   - id: The unique identifier for the profile.
    ///   - level: The new level value.
    ///   - xp: The new experience points value.
    ///   - completion: Called with the result of the operation.
    func patch(id: String, level: Int64, xp: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isProcessing else {
            Logger.debug("[Profile]: Skipping operation - already processing")
            completion(.success(()))
            return
        }
        
        isProcessing = true
        
        Logger.info(
            "[Profile]: Updating profile",
            metadata: [
                "id": id,
                "level": String(level),
                "xp": String(xp)
            ]
        )
        
        performApiOperation(
            { try await self.repository.updateProfile(id: id, level: level, xp: xp) },
            success: { data in
                // Парсим ответ от сервера
                do {
                    let response = try JSONDecoder().decode(ApiModelProfilePatchResponse.self, from: data)
                    
                    Logger.info(
                        "[Profile]: Profile updated successfully",
                        metadata: [
                            "id": id,
                            "serverLevel": String(response.data.level),
                            "serverXp": String(response.data.xp)
                        ]
                    )
                    
                    // Сохраняем полученные данные в локальное хранилище
                    ProfileStorage.shared.set(level: response.data.level, xp: response.data.xp)
                } catch {
                    Logger.warning(
                        "[Profile]: Could not parse profile response",
                        metadata: [
                            "error": error.localizedDescription,
                            "dataSize": String(data.count)
                        ]
                    )
                }
            },
            screen: .Home,
            metadata: [
                "operation": "updateProfile",
                "id": id,
                "level": String(level),
                "xp": String(xp)
            ],
            completion: { [weak self] result in
                guard let self = self else { return }
                
                if case .failure(let error) = result {
                    Logger.error(
                        "[Profile]: Profile update failed",
                        metadata: ["error": error.localizedDescription]
                    )
                }
                
                self.isProcessing = false
                completion(result)
            }
        )
    }
}
