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
    let y = row
    let x = col

    let rackID = x + 10
    var powerLevel = (rackID * y + serialNumber) * rackID
    powerLevel = ((powerLevel / 100) % 10) - 5

    return powerLevel
}

var serialNumber = 9005
var powerValues: [Point : Int] = [:]
var totalPower: [Point : Int] = [:]

// Pre calculate power values
for y in 1...300 {
    for x in 1...300 {
        powerValues[Point(y, x)] = calculatePowerLevel(y, x, serialNumber)
    }
}


for y in 1...300 {
    for x in 1...300 {
        var power = 0
        power += powerValues[Point(y, x)]!
        power += totalPower[Point(y - 1, x), default: 0]
        power += totalPower[Point(y, x - 1), default: 0]
        power -= totalPower[Point(y - 1, x - 1), default: 0]

        totalPower[Point(y, x)] = power
    }
}

var maxPower = Int.min
var maxX = -1
var maxY = -1
var finalSize = -1

for y in 1...300 {
    for x in 1...300 {
        // Stores the total power value of square from x,y to bottom right corner
        let maxSquareSize = 300 - max(x, y)

        for size in 0..<maxSquareSize {
            var power = 0
            power += totalPower[Point(y + size, x + size)]!
            power += totalPower[Point(y, x)]!
            power -= totalPower[Point(y + size, x)]!
            power -= totalPower[Point(y, x + size)]!

            if power > maxPower {
                maxPower = power
                maxX = x
                maxY = y
                finalSize = size
            }
        }
    }
}

print("\(maxX + 1),\(maxY + 1),\(finalSize)")
print(maxPower)

