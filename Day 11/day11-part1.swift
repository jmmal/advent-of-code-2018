#!/usr/bin/swift
import Foundation

class Point: Hashable {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

func calculatePowerLevel(_ row: Int, _ col: Int, _ serialNumber: Int) -> Int {
    let x = row + 1
    let y = col + 1

    let rackID = x + 10
    var powerLevel = (rackID * y + serialNumber) * rackID
    powerLevel = ((powerLevel / 100) % 10) - 5

    return powerLevel
}

func totalPower(_ x: Int, _ y: Int, _ grid: inout [Point : Int], _ serialNumber: Int) -> Int {
    var result = 0
    for i in 0..<3 {
        for j in 0..<3 {
            result += grid[Point(x + i, y + j), default: calculatePowerLevel(x + i, y + j, serialNumber)]
        }
    }

    return result
}

var serialNumber = 9005
var powerValues: [Point : Int] = [:]

var maxPower = Int.min
var maxX = -1
var maxY = -1

for x in 0..<296 {
    for y in 0..<296 {
        let power = totalPower(x, y, &powerValues, serialNumber)
        if power > maxPower {
            maxPower = power
            maxX = x
            maxY = y
        }
    }
}

print("\(maxX + 1),\(maxY + 1)")
print(maxPower)

