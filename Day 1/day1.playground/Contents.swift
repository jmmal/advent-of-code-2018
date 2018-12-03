import UIKit

let testFile = "test-input"

guard let file = Bundle.main.path(forResource: testFile, ofType: "txt") else {
    fatalError()
}

var numbers = [Int]()

do {
    numbers = try String(contentsOfFile: file).components(separatedBy: "\n").compactMap { Int($0) }
} catch {
    fatalError()
}

var currentFrequency = 0
var duplicateFrequency: Int?
var previousFrequencies = Set([0])

for num in numbers {
    currentFrequency += num
}

print("Part 1: \(currentFrequency)")

currentFrequency = 0
while duplicateFrequency == nil {
    for num in numbers {
        currentFrequency += num
        if previousFrequencies.contains(currentFrequency) {
            duplicateFrequency = currentFrequency
            break
        }

        previousFrequencies.insert(currentFrequency)
    }

}
print("Part 2: \(duplicateFrequency)")


