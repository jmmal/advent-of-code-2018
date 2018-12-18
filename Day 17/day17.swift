#!/usr/bin/swift
import Foundation

 // Solution inspired by https://www.reddit.com/r/adventofcode/comments/a6wpup/2018_day_17_solutions/


enum FlowType: String {
    case flowing = "|"
    case resting = "~"
    case clay = "#"
}

enum FlowDirection {
    case left
    case right
    case down
}

struct Point: Hashable {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }

    static func == (lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

let input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 17/day17.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

var grid: [Point : FlowType] = [:]
var minX = Int.max
var minY = Int.max
var maxX = Int.min
var maxY = Int.min

// Read the walls into the grid dictionary
for line in input {
    let firstNumber = Int(line[line.index(line.startIndex, offsetBy: 2)..<line.firstIndex(of: ",")!])!
    let secondNumber = Int(line[line.index(line.lastIndex(of: "=")!, offsetBy: 1)..<line.firstIndex(of: ".")!])!
    let lastNumber = Int(line[line.index(line.lastIndex(of: ".")!, offsetBy: 1)..<line.endIndex])!

    for i in secondNumber...lastNumber {
        var point: Point
        if line[line.startIndex] == "x" {
            minX = min(minX, firstNumber)
            maxX = max(maxX, firstNumber)
            minY = min(minY, i)
            maxY = max(maxY, i)
            point = Point(firstNumber, i)
        } else {
            minX = min(minX, i)
            maxX = max(maxX, i)
            minY = min(minY, firstNumber)
            maxY = max(maxY, firstNumber)
            point = Point(i, firstNumber)
        }

        grid[point] = .clay
    }
}

minX -= 1
maxX += 1

func fill(_ grid: inout [Point: FlowType], _ point: Point, _ direction: FlowDirection = .down) -> Bool {
    grid[point] = .flowing

    let down = Point(point.x, point.y + 1)
    var left = Point(point.x - 1, point.y)
    var right = Point(point.x + 1, point.y)

    if grid[down] != .clay && grid[down] != .resting {
        if grid[down] != .flowing && down.y <= maxY {
            fill(&grid, down)
        }
        if grid[down] != .resting {
            return false
        }
    }

    let filledLeft = grid[left] == .clay || grid[left] != .flowing && fill(&grid, left, .left)
    let filledRight = grid[right] == .clay || grid[right] != .flowing && fill(&grid, right, .right)

    if direction == .down && filledLeft && filledRight {
        grid[point] = .resting

        while grid[left] == .flowing {
            grid[left] = .resting
            left = Point(left.x - 1, left.y)
        }

        while grid[right] == .flowing {
            grid[right] = .resting
            right = Point(right.x + 1, right.y)
        }
    }

    return direction == .left && (filledLeft || grid[left] == .clay) ||
        direction == .right && (filledRight || grid[right] == .clay)
}

let firstPoint = Point(500, 1)
fill(&grid, firstPoint)

let resultPart1 = grid.filter() { $0.key.y >= minY && $0.key.y <= maxY && ($0.value == .resting || $0.value == .flowing) }
let resultPart2 = grid.filter() { $0.key.y >= minY && $0.key.y <= maxY && $0.value == .resting }

print(resultPart1.count)
print(resultPart2.count)



