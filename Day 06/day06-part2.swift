#!/usr/bin/swift
import Foundation

class Coordinate: NSObject {
    let x: Int
    let y: Int
    var area: Int = 0
    var infiniteArea: Bool = false

    init(_ coordinate: String) {
        let split = coordinate.components(separatedBy: CharacterSet.decimalDigits.inverted)
        self.y = Int(split[0])!
        self.x = Int(split[2])!
    }

    func distanceTo(_ row: Int, _ col: Int) -> Int {
        return abs(x - row) + abs(y - col)
    }
}

struct Point {
    var owner: Coordinate?
    var equallyLocated: Bool = false
    var currentDistance: Int = Int.max
}

var input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 06/day06.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

let coordinates = input.map { (coordinate) -> Coordinate in
    Coordinate(coordinate)
}

var gridX = 0
var gridY = 0

coordinates.forEach { (coordinate) in
    gridY = max(gridY, coordinate.x)
    gridX = max(gridX, coordinate.y)
}

var grid: [[Point]] = Array(repeating: Array(repeating: Point(), count: gridX + 1), count: gridY + 1)

var regionSize = 0

for rowIndex in 0..<grid.count {
    for colIndex in 0..<grid[rowIndex].count {
        var totalDistance = 0
        coordinates.forEach { (coordinate) in
            totalDistance += coordinate.distanceTo(rowIndex, colIndex)
        }

        if totalDistance < 10000 {
            regionSize += 1
        }
    }
}

print("Part 2: \(regionSize)")
