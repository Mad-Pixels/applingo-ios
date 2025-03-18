import Foundation
import Combine

/// A class responsible for fetching and managing dictionary data from the database.
/// Handles pagination, search, and data updates with validation and logging.
final class DictionaryGetter: ProcessDatabase {
    // MARK: - Public Properties
    @Published private(set) var dictionaries: [DatabaseModelDictionary] = []
    @Published private(set) var isLoadingPage = false
    @Published private(set) var hasLoadedInitialPage = false
    @Published private(set) var hasLoadingError = false
    
    @Published var searchText: String = "" {
        didSet {
            if searchText != oldValue {
                resetPagination()
            }
        }
    }
    
    // MARK: - Private Properties
    private let dictionaryRepository: DatabaseManagerDictionary
    private var cancellables = Set<AnyCancellable>()
    private var loadingTask: AnyCancellable?
    
    private var cancellationToken = UUID()
    private var hasMorePages = true
    private let itemsPerPage = 50
    private let preloadThreshold = 10
    private var currentPage = 0
    
    // MARK: - Initialization
    init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        
        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        super.init(dbQueue: dbQueue)
        
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public Methods
    
    /// Resets pagination and fetches the first page of dictionaries.
    func resetPagination() {
        Logger.debug("[Dictionary]: Resetting pagination")
        
        // Отменяем текущую загрузку
        loadingTask?.cancel()
        loadingTask = nil
        
        // Сбрасываем состояние
        dictionaries.removeAll()
        hasLoadedInitialPage = false
        currentPage = 0
        hasMorePages = true
        isLoadingPage = false
        hasLoadingError = false
        cancellationToken = UUID()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.fetchDictionaries()
        }
    }
    
    /// Loads more dictionaries if needed based on the current item
    func loadMoreDictionariesIfNeeded(currentItem: DatabaseModelDictionary?) {
        guard
            let dictionary = currentItem,
            let index = dictionaries.firstIndex(where: { $0.id == dictionary.id }),
            index >= dictionaries.count - preloadThreshold,
            hasMorePages,
            !isLoadingPage
        else {
            return
        }
        
        Logger.debug("[Dictionary]: Loading more dictionaries as user scrolled down")
        fetchDictionaries()
    }
    
    /// Updates the active status of a dictionary in the local array
    func updateDictionaryStatus(dictionaryID: Int, newStatus: Bool) {
        guard let index = dictionaries.firstIndex(where: { $0.id == dictionaryID }) else {
            Logger.warning("[Dictionary]: Dictionary not found for status update", metadata: ["id": "\(dictionaryID)"])
            return
        }
        
        var updatedDictionary = dictionaries[index]
        updatedDictionary.isActive = newStatus
        dictionaries[index] = updatedDictionary
        
        Logger.debug("[Dictionary]: Dictionary status updated", metadata: [
            "id": "\(dictionaryID)",
            "status": "\(newStatus)"
        ])
    }
    
    /// Removes a dictionary at the specified index
    func removeDictionary(at index: Int) {
        guard dictionaries.indices.contains(index) else {
            Logger.warning("[Dictionary]: Invalid index for removal", metadata: ["index": "\(index)"])
            return
        }
        
        dictionaries.remove(at: index)
    }
    
    /// Removes the specified dictionary from the array
    func removeDictionary(_ dictionary: DatabaseModelDictionary) {
        guard let index = dictionaries.firstIndex(where: { $0.id == dictionary.id }) else {
            Logger.warning("[Dictionary]: Dictionary not found for removal", metadata: ["name": dictionary.name])
            return
        }
        
        removeDictionary(at: index)
    }
    
    /// Clears all loaded dictionaries
    func clear() {
        loadingTask?.cancel()
        loadingTask = nil
        
        dictionaries.removeAll()
        hasLoadedInitialPage = false
        isLoadingPage = false
        hasLoadingError = false
        currentPage = 0
        hasMorePages = true
        cancellationToken = UUID()
    }
    
    // MARK: - Private Methods
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDictionaryUpdate),
            name: .dictionaryListShouldUpdate,
            object: nil
        )
    }
    
    @objc private func handleDictionaryUpdate() {
        resetPagination()
    }
    
    /// Fetches dictionaries from the database with pagination
    private func fetchDictionaries() {
        // Проверяем состояние
        guard !isLoadingPage, hasMorePages else {
            return
        }
        
        let fetchPage = currentPage
        let fetchToken = cancellationToken
        let fetchOffset = fetchPage * itemsPerPage
        
        isLoadingPage = true
        hasLoadingError = false
        
        Logger.debug(
            "[Dictionary]: Fetching dictionaries",
            metadata: [
                "searchText": searchText,
                "page": "\(fetchPage)",
                "offset": "\(fetchOffset)",
                "limit": "\(itemsPerPage)"
            ]
        )
        
        // Выполняем запрос
        loadingTask = performDatabaseOperation({
            try self.dictionaryRepository.fetch(
                search: self.searchText,
                offset: fetchOffset,
                limit: self.itemsPerPage
            )
        }, screen: screen, metadata: ["searchText": searchText])
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self = self, fetchToken == self.cancellationToken else { return }
            
            self.isLoadingPage = false
            self.loadingTask = nil
            
            if case .failure(let error) = completion {
                self.hasLoadingError = true
                Logger.warning("[Dictionary]: Failed to fetch dictionaries", metadata: ["error": "\(error)"])
            }
        } receiveValue: { [weak self] fetchedDictionaries in
            guard let self = self, fetchToken == self.cancellationToken else { return }
            
            if fetchedDictionaries.isEmpty {
                self.hasMorePages = false
                Logger.debug("[Dictionary]: No more dictionaries to fetch")
            } else {
                self.currentPage += 1
                
                let validDictionaries = fetchedDictionaries.filter { !$0.name.isEmpty }
                
                if validDictionaries.count != fetchedDictionaries.count {
                    Logger.warning(
                        "[Dictionary]: Some dictionaries were filtered out",
                        metadata: [
                            "original": "\(fetchedDictionaries.count)",
                            "valid": "\(validDictionaries.count)"
                        ]
                    )
                }
                
                if !validDictionaries.isEmpty {
                    self.dictionaries.append(contentsOf: validDictionaries)
                    Logger.debug(
                        "[Dictionary]: Dictionaries appended",
                        metadata: [
                            "added": "\(validDictionaries.count)",
                            "total": "\(self.dictionaries.count)"
                        ]
                    )
                }
                
                if fetchedDictionaries.count < self.itemsPerPage {
                    self.hasMorePages = false
                    Logger.debug("[Dictionary]: End of the list (incomplete page)")
                }
            }
            
            self.hasLoadedInitialPage = true
            self.isLoadingPage = false
        }
    }
}
