import UIKit

let text = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 2/day02.playground/Resources/input.txt")
let boxIDs: [String] = text.components(separatedBy: "\n")

var letterCounts: [Character:Int] = [:]

var twos = 0
var threes = 0

boxIDs.forEach { id in
    id.forEach { character in
        letterCounts[character] = (letterCounts[character] ?? 0) + 1
    }

    let containsDoubleLetter = letterCounts.filter( { $0.value == 2} ).count > 0
    let containsTripleLetter = letterCounts.filter( { $0.value == 3} ).count > 0

    if containsDoubleLetter {
        twos += 1
    }

    if containsTripleLetter {
        threes += 1
    }

    letterCounts = [:]
}

print(twos * threes)

boxIDs.forEach { baseId in
    boxIDs.forEach { id in
        var numberOfDifferingCharacters = 0

        for (char1, char2) in zip(Array(baseId), Array(id)) {
            if char1 != char2 {
                numberOfDifferingCharacters += 1
            }

            if numberOfDifferingCharacters > 2 {
                break
            }
        }

        if numberOfDifferingCharacters == 1 {
            print(baseId)
            print(id)
        }
    }
}
