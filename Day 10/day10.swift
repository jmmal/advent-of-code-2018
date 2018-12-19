#!/usr/bin/swift
import Foundation

class Point: Hashable {
    var positionX: Int
    var positionY: Int
    let velocityX: Int
    let velocityY: Int

    init(_ px: Int,_ py: Int,_ vx: Int,_ vy: Int) {
        self.positionX = px
        self.positionY = py
        self.velocityX = vx
        self.velocityY = vy
    }

    func tick() -> Point {
        positionX += velocityX
        positionY += velocityY

        return self
    }

    func copy() -> Point {
        return Point(positionX, positionY, velocityX, velocityY)
    }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.positionX == rhs.positionX && lhs.positionY == rhs.positionY
    }

    var hashValue: Int {
        return positionX + 1000 * positionY
    }
}

func printPoints(_ data: [Point], _ minX: Int, _ maxX: Int, _ minY: Int, _ maxY: Int) {
    for x in minX...maxX {
        for y in minY...maxY {
            if data.contains(Point(x, y, 0, 0)) {
                print("#", terminator: "")
            } else {
                print(".", terminator: "")
            }
        }
        print()
    }
}

let input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 10/day10.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

var points: [Point] = []
var minX = Int.max
var minY = Int.max
var maxX = Int.min
var maxY = Int.min

input.forEach { (pointString) in
    let positionStart = pointString.index(pointString.firstIndex(of: "<")!, offsetBy: 1)
    let positionEnd = pointString.firstIndex(of: ">")!
    let velocityStart = pointString.index(pointString.lastIndex(of: "<")!, offsetBy: 1)
    let velocityEnd = pointString.lastIndex(of: ">")!

    let position = pointString[positionStart..<positionEnd].components(separatedBy: ",").compactMap { $0.trimmingCharacters(in: .whitespaces) }
    let velocity = pointString[velocityStart..<velocityEnd].components(separatedBy: ",").compactMap { $0.trimmingCharacters(in: .whitespaces ) }

    let px = Int(position[1])!
    let py = Int(position[0])!
    let vx = Int(velocity[1])!
    let vy = Int(velocity[0])!

    minX = min(px, minX)
    maxX = max(px, maxX)
    minY = min(py, minY)
    maxY = max(py, maxY)

    points.append(Point(px, py, vx, vy))
}

var seconds = 0
var area = abs(maxX - minX) * abs(maxY - minY)
var previousArea = Int.max
var previousPoints: [Point] = []
var previous = (0, 0, 0, 0)

while area < previousArea {
    previousArea = area
    previousPoints = points.map{$0.copy()}
    previous = (minX, maxX, minY, maxY)

    minX = Int.max
    maxX = Int.min
    minY = Int.max
    maxY = Int.min

    for point in points {
        let result = point.tick()

        minX = min(result.positionX, minX)
        minY = min(result.positionY, minY)
        maxX = max(result.positionX, maxX)
        maxY = max(result.positionY, maxY)
    }

    area = (maxX - minX) * (maxY - minY)

    seconds += 1
}

print("Second: \(seconds - 1)")
printPoints(previousPoints, previous.0, previous.1, previous.2, previous.3)
