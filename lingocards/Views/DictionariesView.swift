// Views/DictionariesView.swift
import SwiftUI


struct DictionariesView: View {
    @EnvironmentObject var appState: AppState // Подключаем appState как EnvironmentObject
    @EnvironmentObject var localizationManager: LocalizationManager // Подключаем localizationManager как EnvironmentObject
    @StateObject private var viewModel: DictionariesViewModel

    // Инициализация ViewModel с передачей appState
    init() {
        _viewModel = StateObject(wrappedValue: DictionariesViewModel(appState: AppState.shared))
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Основной список словарей
                List {
                    ForEach(viewModel.dictionaries) { dictionary in
                        DictionaryRow(dictionary: dictionary)
                            .contentShape(Rectangle()) // Убедимся, что вся строка реагирует на нажатие
                            .onTapGesture {
                                viewModel.showDictionaryDetails(dictionary)
                            }
                    }
                    .onDelete(perform: viewModel.deleteDictionary)
                }
                .navigationTitle(localizationManager.localizedString(for: "Dictionaries"))

                // Плавающая кнопка "+"
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
                        .buttonStyle(FloatingButtonStyle()) // Применение стиля кнопки
                        .padding()
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddOptions) {
                AddDictionaryOptionsView(viewModel: viewModel)
                    .environmentObject(appState) // Передаём appState в представление
            }
            .sheet(isPresented: $viewModel.showDownloadServer) {
                ServerDictionariesView(viewModel: viewModel)
                    .environmentObject(appState) // Передаём appState в представление
            }
            .sheet(item: $viewModel.selectedDictionary) { dictionary in
                DictionaryDetailView(dictionary: dictionary, viewModel: viewModel)
                    .environmentObject(appState) // Передаём appState в представление
            }
            .alert(item: $viewModel.activeAlert) { activeAlert in
                // Обработка алертов
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
                viewModel.loadDictionaries() // Загружаем словари при появлении экрана
            }
            .onDisappear {
                viewModel.cancelLoading() // Отмена загрузки при уходе с экрана
            }
        }
    }
}

// Субпредставления
struct DictionaryRow: View {
    var dictionary: DictionaryItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dictionary.name)
                    .font(.headline)
                Text(dictionary.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct AddDictionaryOptionsView: View {
    @ObservedObject var viewModel: DictionariesViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Button(action: {
                    viewModel.importCSV()
                }) {
                    Text("Import CSV")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                //.buttonStyle(PrimaryButtonStyle())
                
                Button(action: {
                    viewModel.fetchDictionariesFromServer()
                }) {
                    Text("Download from Server")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                //.buttonStyle(PrimaryButtonStyle())
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Dictionary")
            .navigationBarItems(trailing: Button("Close") {
                viewModel.showAddOptions = false
            })
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
                    ForEach(viewModel.serverDictionaries) { dictionary in
                        DictionaryRow(dictionary: dictionary)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.selectedDictionary = dictionary
                                showDetailPopup = true
                            }
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
                        }

                        Text(selectedDictionary.name)
                            .font(.title)
                            .padding()

                        Text(selectedDictionary.description)
                            .padding()

                        Spacer()

                        Button("Download") {
                            viewModel.downloadSelectedDictionary(selectedDictionary)
                            showDetailPopup = false
                        }
                        .padding()
                    }
                    .frame(width: 300, height: 300)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
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
            Text(dictionary.description)
                .padding()
            Spacer()
            HStack {
                Button("Edit") {
                    // Обработка редактирования
                    // Можно открыть форму редактирования
                }
                .padding()
                Spacer()
                Button("Delete") {
                    viewModel.showNotify(
                        title: "Delete Dictionary",
                        message: "Are you sure you want to delete this dictionary?",
                        primaryAction: {
                            // Удаляем запись
                            if let index = viewModel.dictionaries.firstIndex(where: { $0.id == dictionary.id }) {
                                viewModel.dictionaries.remove(at: index)
                            }
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                .padding()
            }
        }
        .padding()
    }
}
