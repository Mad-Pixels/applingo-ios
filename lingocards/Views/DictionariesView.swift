// Views/DictionariesView.swift
import SwiftUI

struct DictionariesView: View {
    @StateObject private var viewModel = DictionariesViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager // Для локализации

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.dictionaries) { dictionary in
                    DictionaryRow(dictionary: dictionary)
                        .contentShape(Rectangle()) // Чтобы весь ряд реагировал на нажатие
                        .onTapGesture {
                            // Показ деталей
                            viewModel.showDictionaryDetails(dictionary)
                        }
                }
                .onDelete(perform: viewModel.deleteDictionary)
            }
            .navigationTitle(localizationManager.localizedString(for: "Dictionaries"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showAddOptions = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddOptions) {
                AddDictionaryOptionsView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showDownloadServer) {
                ServerDictionariesView(viewModel: viewModel)
            }
            .sheet(item: $viewModel.selectedDictionary) { dictionary in
                DictionaryDetailView(dictionary: dictionary, viewModel: viewModel)
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
        }
    }
}

// Субпредставления
struct DictionaryRow: View {
    var dictionary: DictionaryItem

    var body: some View {
        HStack {
            Text(dictionary.name)
            Spacer()
            Text(dictionary.description)
        }
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

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.serverDictionaries) { dictionary in
                    DictionaryRow(dictionary: dictionary)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // Обработка выбора
                            // Например, добавление в локальный список
                            viewModel.dictionaries.append(dictionary)
                            viewModel.showDownloadServer = false
                        }
                }
            }
            .navigationTitle("Server Dictionaries")
            .navigationBarItems(trailing: Button("Close") {
                viewModel.showDownloadServer = false
            })
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
