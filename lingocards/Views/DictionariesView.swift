// Views/DictionariesView.swift
import SwiftUI

struct DictionariesView: View {
    @StateObject private var viewModel = DictionariesViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.dictionaries) { dictionary in
                        DictionaryRow(dictionary: dictionary)
                            .contentShape(Rectangle())
                            .onTapGesture {
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
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.showAddOptions = true
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddOptions) {
                AddDictionaryOptionsView(viewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showDownloadServer) {
                ServerDictionariesView(viewModel: viewModel)
            }
            .alert(item: $viewModel.activeAlert) { activeAlert in
                switch activeAlert {
                case .alert(let alertItem):
                    return Alert(
                        title: Text(alertItem.title),
                        message: Text(alertItem.message),
                        dismissButton: .default(Text("OK"))
                    )
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
    @State private var showDetailPopup = false

    var body: some View {
        ZStack {
            NavigationView {
                List {
                    ForEach(viewModel.serverDictionaries) { dictionary in
                        DictionaryRow(dictionary: dictionary)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                // Показ всплывающего окна с детальной информацией
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
            
            // Кастомное всплывающее окно с детальной информацией
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
                            viewModel.dictionaries.append(selectedDictionary)
                            showDetailPopup = false // Закрываем окно после загрузки
                        }
                        //.buttonStyle(PrimaryButtonStyle())
                        .padding()
                    }
                    .frame(width: 300, height: 300)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.4)) // Задний фон
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
