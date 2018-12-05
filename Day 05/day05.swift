#!/usr/bin/swift
import Foundation

let input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 05/day05.playground/Resources/input.txt").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

let lowercaseLetters = CharacterSet.lowercaseLetters
let uppercaseLetters = CharacterSet.uppercaseLetters

func reducePolymers(_ polymerString: String) -> Int {
    var polyArray = polymerString.map { String($0) }

    var left = 0
    var right  = 1

    while right < polyArray.count {
        if let scala = UnicodeScalar(polyArray[left]) {
            if lowercaseLetters.contains(scala) && polyArray[left].uppercased() == polyArray[right] {
                polyArray[left] = "-"
                polyArray[right] = "-"

                while left >= 0 && polyArray[left] == "-" {
                    left -= 1
                }
                right += 1
            } else if uppercaseLetters.contains(scala) && polyArray[left].lowercased() == polyArray[right] {
                polyArray[left] = "-"
                polyArray[right] = "-"

                while left >= 0 && polyArray[left] == "-" {
                    left -= 1
                }
                right += 1
            } else {
                left += 1
                right += 1
            }
        }

        if left < 0 {
            left = 0
        }

        while left < polyArray.count - 1 && polyArray[left] == "-" {
            left += 1
        }

        if left >= right {
            right = left + 1
        }
    }

    return polyArray.joined().replacingOccurrences(of: "-", with: "").count
}

let part1Result = reducePolymers(input)
print("Part 1: \(part1Result)")

var min = Int.max
for char in "abcdefghijklmnopqrstuvwxyz" {
    let toRemove = String(char)
    var polymer = input
    polymer = polymer.replacingOccurrences(of: toRemove, with: "")
    polymer = polymer.replacingOccurrences(of: toRemove.uppercased(), with: "")

    let result = reducePolymers(polymer)
    if  result < min {
        min = result
    }
}

print(min)

