#!/usr/bin/swift
import Foundation

func reducePolymers(_ polymerString: String) -> Int {
    var reduced: [String] = []
    let lowercaseLetters = CharacterSet.lowercaseLetters
    let uppercaseLetters = CharacterSet.uppercaseLetters

    for character in polymerString {
        if let left = reduced.popLast() {
            if !(lowercaseLetters.contains(UnicodeScalar(left)!) && String(character) == left.uppercased())
            && !(uppercaseLetters.contains(UnicodeScalar(left)!) && String(character) == left.lowercased()) {
                reduced.append(left)
                reduced.append(String(character))
            }
        } else {
            reduced.append(String(character))
        }
    }

    return reduced.count
}

let input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 05/day05.playground/Resources/input.txt").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

let part1Result = reducePolymers(input)
print("Part 1: \(part1Result), expected: 11546")

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

print("Part 2: \(min), expected: 5124")

