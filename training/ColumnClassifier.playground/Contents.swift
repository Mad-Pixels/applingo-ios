import CreateML
import Foundation

do {
    // Получаем текущий рабочий каталог
    let currentDirectory = FileManager.default.currentDirectoryPath
    print("Current directory: \(currentDirectory)")
    
    // Убедимся, что файл находится в нужной директории
    let currentDirectoryURL = URL(fileURLWithPath: currentDirectory)
    
    // Укажите правильный относительный путь к файлу или используйте абсолютный путь
    let dataURL = currentDirectoryURL.appendingPathComponent("/Users/igoss/Desktop/lingocards-ios/training/ColumnClassifierDataSet.csv") // Убедитесь, что путь правильный
    print("Absolute path to data file: \(dataURL.path)")

    var data = try MLDataTable(contentsOf: dataURL)
    print("Loaded \(data.rows.count) rows with \(data.columnNames.count) columns.")

    let featureColumns = ["Language", "Length", "Column Index", "Is Empty"]
    let featureData = data[featureColumns + ["Label"]]

    let (trainingData, testingData) = featureData.randomSplit(by: 0.8, seed: 42)

    if let languageColumn = trainingData["Language"] as? MLDataColumn<String> {
        let languageArray = Array(languageColumn)
        let uniqueLanguages = Set(languageArray)
        print("Unique languages in training data: \(uniqueLanguages)")
    } else {
        print("Column 'Language' does not contain string data.")
    }

    let parameters = MLRandomForestClassifier.ModelParameters(
        maxIterations: 100,
        minLossReduction: 0.0,
        minChildWeight: 0.0,
        randomSeed: 42
    )

    let classifier = try MLRandomForestClassifier(
        trainingData: trainingData,
        targetColumn: "Label",
        parameters: parameters
    )

    let trainingAccuracy = (1.0 - classifier.trainingMetrics.classificationError) * 100
    print("Training Accuracy: \(trainingAccuracy)%")

    let evaluationMetrics = classifier.evaluation(on: testingData)
    let validationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100
    print("Validation Accuracy: \(validationAccuracy)%")

    // Сохраняем модель
    let modelURL = currentDirectoryURL.appendingPathComponent("/Users/igoss/Desktop/lingocards-ios/lingocards/ML/ColumnClassifier.mlmodel")
    print("Absolute path to model file: \(modelURL.path)")

    try classifier.write(to: modelURL)

    print(classifier.description)

} catch {
    print("An error occurred: \(error)")
}
