import SwiftUI

struct TabWordsView: View {
    @StateObject private var viewModel = TabWordsViewModel()
    @State private var selectedWord: WordItem?
    @State private var isShowingDetail = false

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $viewModel.searchText)

                List(viewModel.words) { word in
                    HStack {
                        Text(word.frontText)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Image(systemName: "arrow.left.and.right.circle.fill")
                            .foregroundColor(.blue)

                        Text(word.backText)
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedWord = word
                        isShowingDetail = true
                    }
                }
            }
            .navigationTitle("Words")
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(item: $selectedWord) { word in
            WordDetailView(word: word, isPresented: $isShowingDetail, onSave: viewModel.updateWord)
        }
    }
}



struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text("Search...")
                        .foregroundColor(.gray)
                }
                
                TextField("", text: $searchText)
                    .foregroundColor(.primary)
            }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct WordDetailView: View {
    @State private var editedWord: WordItem
    @Binding var isPresented: Bool
    @State private var isEditing = false
    let onSave: (WordItem) -> Void
    
    init(word: WordItem, isPresented: Binding<Bool>, onSave: @escaping (WordItem) -> Void) {
        _editedWord = State(initialValue: word)
        _isPresented = isPresented
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Word")) {
                    TextField("Front Text", text: $editedWord.frontText)
                        .disabled(!isEditing)
                    TextField("Back Text", text: $editedWord.backText)
                        .disabled(!isEditing)
                }
                
                Section(header: Text("Additional Information")) {
                    TextField("Description", text: Binding(
                        get: { editedWord.description ?? "" },
                        set: { editedWord.description = $0.isEmpty ? nil : $0 }
                    ))
                    .disabled(!isEditing)
                    
                    TextField("Hint", text: Binding(
                        get: { editedWord.hint ?? "" },
                        set: { editedWord.hint = $0.isEmpty ? nil : $0 }
                    ))
                    .disabled(!isEditing)
                }
                
                Section(header: Text("Statistics")) {
                    Text("Created: \(Date(timeIntervalSince1970: TimeInterval(editedWord.createdAt)), style: .date)")
                    Text("Success: \(editedWord.success)")
                    Text("Fail: \(editedWord.fail)")
                    Text("Weight: \(editedWord.weight)")
                }
            }
            .navigationTitle("Word Details")
            .navigationBarItems(
                leading: Button(isEditing ? "Cancel" : "Close") {
                    if isEditing {
                        isEditing = false
                        editedWord = editedWord  // Reset to original values
                    } else {
                        isPresented = false
                    }
                },
                trailing: Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        onSave(editedWord)
                        isEditing = false
                    } else {
                        isEditing = true
                    }
                }
            )
        }
    }
}
