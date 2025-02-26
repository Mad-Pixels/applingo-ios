import GRDB

/// A manager responsible for handling database transactions.
/// This manager provides methods for atomic database operations involving both dictionaries and words.
final class DatabaseManagerTransaction {
   // MARK: - Properties
   
   private let dictionaryManager: DatabaseManagerDictionary
   private let wordManager: DatabaseManagerWord
   
   // MARK: - Initialization
   
   /// Initializes the transaction manager with the required database managers.
   /// - Parameters:
   ///   - dictionaryManager: Manager for dictionary operations.
   ///   - wordManager: Manager for word operations.
   init(
       dictionaryManager: DatabaseManagerDictionary,
       wordManager: DatabaseManagerWord
   ) {
       self.dictionaryManager = dictionaryManager
       self.wordManager = wordManager
   }
   
   // MARK: - Public Methods
   
   /// Saves a dictionary and its associated words within an existing database transaction.
   /// This method ensures that both dictionary and words are saved atomically.
   ///
   /// - Parameters:
   ///   - dictionary: The dictionary to save.
   ///   - words: Array of words associated with the dictionary.
   ///   - db: The database instance from the current transaction.
   /// - Throws: DatabaseError if validation fails or database operations fail.
   func save(
       dictionary: DatabaseModelDictionary,
       words: [DatabaseModelWord],
       db: Database
   ) throws {
       // Save dictionary first as words depend on it
       try saveDictionary(dictionary, db: db)
       
       // Then save all associated words
       for word in words {
           try saveWord(word, db: db)
       }
       
       Logger.debug(
           "[Database]: Successfully saved dictionary and words",
           metadata: [
               "dictionary_guid": dictionary.guid,
               "words_count": String(words.count)
           ]
       )
   }
   
   // MARK: - Private Methods
   
   /// Saves a dictionary within an existing transaction.
   /// - Parameters:
   ///   - dictionary: The dictionary to save.
   ///   - db: The database instance from the current transaction.
   private func saveDictionary(_ dictionary: DatabaseModelDictionary, db: Database) throws {
       guard isValidDictionary(dictionary) else {
           throw DatabaseError.invalidWord(details: "Invalid dictionary data")
       }
       
       let formattedDictionary = formatDictionary(dictionary)
       
       do {
           try formattedDictionary.insert(db)
           Logger.debug(
               "[Database]: Dictionary saved",
               metadata: [
                   "id": formattedDictionary.id ?? -1,
                   "guid": formattedDictionary.guid,
                   "name": formattedDictionary.name
               ]
           )
       } catch let error as GRDB.DatabaseError {
           if error.resultCode == .SQLITE_CONSTRAINT {
               throw DatabaseError.duplicateDictionary(dictionary: formattedDictionary.name)
           }
           throw DatabaseError.saveFailed(details: error.localizedDescription)
       } catch {
           throw DatabaseError.saveFailed(details: error.localizedDescription)
       }
   }
   
   /// Saves a word within an existing transaction.
   /// - Parameters:
   ///   - word: The word to save.
   ///   - db: The database instance from the current transaction.
   private func saveWord(_ word: DatabaseModelWord, db: Database) throws {
       guard isValidWord(word) else {
           throw DatabaseError.invalidWord(details: "Invalid word data")
       }
       
       let formattedWord = formatWord(word)
       
       do {
           try formattedWord.upsert(db)
           Logger.debug(
               "[Database]: Word saved",
               metadata: [
                   "id": formattedWord.id ?? -1,
                   "uuid": formattedWord.uuid,
                   "frontText": formattedWord.frontText
               ]
           )
       } catch let error as GRDB.DatabaseError {
           if error.resultCode == .SQLITE_CONSTRAINT {
               throw DatabaseError.duplicateWord(word: formattedWord.frontText)
           }
           throw DatabaseError.saveFailed(details: error.localizedDescription)
       } catch {
           throw DatabaseError.saveFailed(details: error.localizedDescription)
       }
   }
   
   /// Formats dictionary data for database operations.
   private func formatDictionary(_ dictionary: DatabaseModelDictionary) -> DatabaseModelDictionary {
       var formatted = dictionary
       formatted.fmt()
       return formatted
   }
   
   /// Validates dictionary data.
   private func isValidDictionary(_ dictionary: DatabaseModelDictionary) -> Bool {
       !dictionary.name.isEmpty && !dictionary.guid.isEmpty
   }
   
   /// Formats word data for database operations.
   private func formatWord(_ word: DatabaseModelWord) -> DatabaseModelWord {
       var formatted = word
       formatted.fmt()
       return formatted
   }
   
   /// Validates word data.
   private func isValidWord(_ word: DatabaseModelWord) -> Bool {
       !word.frontText.isEmpty &&
       !word.backText.isEmpty &&
       !word.dictionary.isEmpty
   }
}
