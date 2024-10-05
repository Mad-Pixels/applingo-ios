// Views/DictionariesView.swift
import SwiftUI
import Hero


struct DictionariesView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var viewModel: DictionariesViewModel

    init() {
        _viewModel = StateObject(wrappedValue: DictionariesViewModel(appState: AppState.shared))
    }

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.dictionaries.indices, id: \.self) { index in
                        DictionaryRow(dictionary: $viewModel.dictionaries[index]) { id, isActive in
                            viewModel.updateDictionaryStatus(id: id, isActive: isActive)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedDictionary = viewModel.dictionaries[index]
                            viewModel.showDictionaryDetails(viewModel.dictionaries[index])
                        }
                        .heroModifier(String(viewModel.dictionaries[index].id))
                    }
                    .onDelete(perform: viewModel.deleteDictionary)
                }
                .navigationTitle(localizationManager.localizedString(for: "Dictionaries"))

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.showAddOptions = true
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(FloatingButtonStyle())
                        .padding()
                        .heroModifier("addButton")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddOptions) {
                AddDictionaryOptionsView(viewModel: viewModel)
                    .environmentObject(appState)
                    .heroEnabled()
            }
            .sheet(isPresented: $viewModel.showDownloadServer) {
                ServerDictionariesView(viewModel: viewModel)
                    .environmentObject(appState)
                    .heroEnabled()
            }
            .sheet(item: $viewModel.selectedDictionary) { dictionary in
                DictionaryDetailView(dictionary: dictionary, viewModel: viewModel)
                    .environmentObject(appState)
                    .heroEnabled()
            }
            .alert(item: $viewModel.activeAlert) { activeAlert in
                switch activeAlert {
                case .alert(let alertItem):
                    return Alert(title: Text(alertItem.title), message: Text(alertItem.message), dismissButton: .default(Text("OK")))
                case .notify(let notifyItem):
                    return Alert(
                        title: Text(notifyItem.title),
                        message: Text(notifyItem.message),
                        primaryButton: .default(Text("OK"), action: notifyItem.primaryAction),
                        secondaryButton: .cancel(Text("Cancel"), action: notifyItem.secondaryAction ?? {})
                    )
                }
            }
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                    }
                }
            )
            .onAppear {
                viewModel.loadDictionaries()
            }
            .onDisappear {
                viewModel.cancelLoading()
            }
        }
    }
}


extension View {
    /// Включаем Hero для любых представлений SwiftUI
    func heroEnabled() -> some View {
        self.background(HeroModifierView())
    }

    /// Добавляем hero модификатор с уникальным идентификатором
    func heroModifier(_ heroID: String) -> some View {
        self.modifier(HeroViewModifier(heroID: heroID))
    }
}

struct HeroViewModifier: ViewModifier {
    let heroID: String

    func body(content: Content) -> some View {
        content
            .background(HeroModifierView(heroID: heroID))
    }
}

struct HeroModifierView: UIViewRepresentable {
    let heroID: String?

    init(heroID: String? = nil) {
        self.heroID = heroID
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if let heroID = heroID {
            view.heroID = heroID
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


struct DictionaryRow: View {
    @Binding var dictionary: DictionaryItem
    var onToggle: (Int64, Bool) -> Void

    var body: some View {
        HStack {
            Toggle(isOn: $dictionary.isActive) {
                EmptyView()
            }
            .onChange(of: dictionary.isActive) { newValue in
                onToggle(dictionary.id, newValue)
            }
            VStack(alignment: .leading) {
                Text(dictionary.name)
                    .font(.headline)
                Text(dictionary.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        //.toggleStyle(CheckboxToggleStyle())
    }
}

struct AddDictionaryOptionsView: View {
    @ObservedObject var viewModel: DictionariesViewModel
    @State private var showDocumentPicker = false
    @State private var selectedFileURL: URL?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    showDocumentPicker = true
                }) {
                    Text("Import CSV")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .heroModifier("importCSVButton")
                }

                Button(action: {
                    viewModel.fetchDictionariesFromServer()
                }) {
                    Text("Download from Server")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .heroModifier("downloadServerButton")
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Add Dictionary")
            .navigationBarItems(trailing: Button("Close") {
                viewModel.showAddOptions = false
            })
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker(selectedFileURL: $selectedFileURL) { url in
                    // viewModel.importCSV(from: url) // Implement this logic
                }
            }
            .heroEnabled() // Включаем Hero для листа
        }
    }
}


struct ServerDictionariesView: View {
    @ObservedObject var viewModel: DictionariesViewModel
    @State private var showDetailPopup = false

    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.serverDictionaries.indices, id: \ .self) { index in
                        DictionaryRow(dictionary: $viewModel.serverDictionaries[index]) { id, isActive in
                            viewModel.updateDictionaryStatus(id: id, isActive: isActive)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedDictionary = viewModel.serverDictionaries[index]
                            showDetailPopup = true
                        }
                        .heroModifier(String(viewModel.serverDictionaries[index].id))
                    }
                }
                .navigationTitle("Server Dictionaries")
                .navigationBarItems(trailing: Button("Close") {
                    viewModel.showDownloadServer = false
                })
            }

            if let selectedDictionary = viewModel.selectedDictionary, showDetailPopup {
                VStack {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                showDetailPopup = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 24))
                            }
                            .padding()
                            .heroModifier("closeButton")
                        }

                        Text(selectedDictionary.name)
                            .font(.title)
                            .padding()
                            .heroModifier("serverDictionaryName_\(selectedDictionary.id)")

                        Text(selectedDictionary.description)
                            .padding()
                            .heroModifier("serverDictionaryDescription_\(selectedDictionary.id)")

                        Spacer()

                        Button("Download") {
                            viewModel.downloadSelectedDictionary(selectedDictionary)
                            showDetailPopup = false
                        }
                        .padding()
                        .heroModifier("downloadButton")
                    }
                    .frame(width: 300, height: 300)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .heroEnabled() // Включаем Hero для модального окна
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.4))
                .transition(.opacity)
                .animation(.easeInOut)
            }
        }
    }
}

struct DictionaryDetailView: View {
    var dictionary: DictionaryItem
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DictionariesViewModel

    var body: some View {
        VStack {
            Text(dictionary.name)
                .font(.title)
                .padding()
                .heroModifier("dictionaryName_\(dictionary.id)")
            Text(dictionary.description)
                .padding()
                .heroModifier("dictionaryDescription_\(dictionary.id)")
            Spacer()
            HStack {
                Button("Edit") {
                    // Обработка редактирования
                }
                .padding()
                .heroModifier("editButton_\(dictionary.id)")
                Spacer()
                Button("Delete") {
                    viewModel.showNotify(
                        title: "Delete Dictionary",
                        message: "Are you sure you want to delete this dictionary?",
                        primaryAction: {
                            if let index = viewModel.dictionaries.firstIndex(where: { $0.id == dictionary.id }) {
                                viewModel.dictionaries.remove(at: index)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                .padding()
                .heroModifier("deleteButton_\(dictionary.id)")
            }
        }
        .padding()
        .heroEnabled() // Включаем Hero для DictionaryDetailView
    }
}
