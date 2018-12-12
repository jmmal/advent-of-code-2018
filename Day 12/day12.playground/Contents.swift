import Foundation

let input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 12/day12.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

// Gets the array of pot plants
let plantString = input[0]
let startIndex = plantString.index(plantString.startIndex, offsetBy: 15)
var plants = Array(plantString[startIndex..<plantString.endIndex])

var mutations: [String : String] = [:]

for i in 2..<input.count {
    let str = input[i]

    let endIndex = str.index(str.startIndex, offsetBy: 4)
    let mutationString = String(str[str.startIndex...endIndex])
    let result = String(str.last!)

    mutations[mutationString] = result
}

// Change extensionSize to 300 for part 2
let extensionSize = 60
plants = Array(repeating: ".", count: extensionSize) + plants + Array(repeating: ".", count: extensionSize)

var generationNumber = 0
var maxGenerations = 20
for _ in 1...20 {
    generationNumber += 1

    var temp: [Character] = []
    for potNumber in 0..<plants.count {
        let secondLeft = String(plants[((potNumber - 2) % plants.count + plants.count) % plants.count])
        let firstLeft  = String(plants[((potNumber - 1) % plants.count + plants.count) % plants.count])
        let firstRight = String(plants[((potNumber + 1) % plants.count + plants.count) % plants.count])
        let secondRight = String(plants[((potNumber + 2) % plants.count + plants.count) % plants.count])

        var potString = "" + secondLeft + firstLeft
        potString += String(plants[potNumber]) + firstRight + secondRight

        if let mutation = mutations[potString] {
            temp.append(Character(mutation))
        } else {
            temp.append(".")
        }
    }

    plants = temp
    temp = []

    print(String(plants))
    // Part 2: Used to recognise pattern in the plant growth
    //    var sum = 0
    //    if generationNumber % 100 == 0 {
    //        for potNumber in 0..<plants.count {
    //            if plants[potNumber] == "#" {
    //                sum += potNumber - extensionSize
    //            }
    //        }
    //        print(sum)
    //    }
}

// Calculates the sum of indices of indices for part 1
var sum = 0
for potNumber in 0..<plants.count {
    if plants[potNumber] == "#" {
        sum += potNumber - extensionSize
    }
}

print(sum)
