import UIKit

let input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/day03/day03.playground/Resources/input.txt")
let claims: [String] = input.components(separatedBy: "\n")

var carpet = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)
var carpetClaimer = Array(repeating: Array(repeating: 0, count: 1000), count: 1000)

var conflictingClaims = Set<Int>()

claims.forEach { (claim) in
    let stringArray = claim.components(separatedBy: CharacterSet.decimalDigits.inverted)

    if stringArray.count == 9 {
        let claimNumber = Int(stringArray[1])!
        let row = Int(stringArray[4])!
        let col = Int(stringArray[5])!
        let width = Int(stringArray[7])!
        let height = Int(stringArray[8])!

        for i in row..<row+width {
            for j in col..<col+height {
                carpet[i][j] += 1

                if carpetClaimer[i][j] != 0 {
                    conflictingClaims.insert(claimNumber)
                    conflictingClaims.insert(carpetClaimer[i][j])
                }

                carpetClaimer[i][j] = claimNumber
            }
        }
    }
}

var twoOrMoreClaims = 0

for i in 0..<1000 {
    for j in 0..<1000 {
        if carpet[i][j] > 1 {
            twoOrMoreClaims += 1
        }
    }
}

print(twoOrMoreClaims)

for i in 1..<claims.count {
    if !conflictingClaims.contains(i) {
        print(i)
    }
}



