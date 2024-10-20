import CreateML
import Foundation

let dataURL = URL(fileURLWithPath: "./ColumnClassifierDataSet.csv")
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
    print("Raw 'Language' does not exist in training data.")
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

let modelURL = URL(fileURLWithPath: "../lingocards/ML/ColumnClassifier.mlmodel")
try classifier.write(to: modelURL)

print(classifier.description)
