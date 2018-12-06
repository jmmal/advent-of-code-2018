#!/usr/bin/swift
import Foundation

class Coordinate: NSObject {
    let x: Int
    let y: Int
    var area: Int = 0
    var hasInfiniteArea: Bool = false

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

for rowIndex in 0..<grid.count {
    for colIndex in 0..<grid[rowIndex].count {
        var point = grid[rowIndex][colIndex]
        var closestCoordinate: Coordinate? = nil

        coordinates.forEach { (coordinate) in
            let distance = coordinate.distanceTo(rowIndex, colIndex)

            if distance < point.currentDistance {
                point.currentDistance = distance
                closestCoordinate = coordinate
                point.equallyLocated = false
            } else if distance == point.currentDistance {
                point.equallyLocated = true
            }
        }

        if !point.equallyLocated {
            point.owner = closestCoordinate
            point.owner?.area += 1

            if rowIndex == 0 || rowIndex == grid.count - 1 || colIndex == 0 || colIndex == grid[0].count - 1 {
                point.owner?.hasInfiniteArea = true
            }
        }

        grid[rowIndex][colIndex] = point
    }
}

let nonInfiniteCoodinates = coordinates.filter { (coordinate) -> Bool in
    !coordinate.hasInfiniteArea
}

let maxArea = nonInfiniteCoodinates.max { (c1, c2) -> Bool in
    (c1.area < c2.area)
}

print("Part 1: \(maxArea!.area)")
