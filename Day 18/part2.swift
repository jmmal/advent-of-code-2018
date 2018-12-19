#!/usr/bin/swift
import Foundation

enum AcreType: String {
    case open = "."
    case trees = "|"
    case lumberYard = "#"
}

struct Acre: Hashable {
    let row: Int
    let col: Int

    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }

    static func == (lhs: Acre, rhs: Acre) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }

    var describing: String {
        return "\(row),\(col)"
    }
}

func printLandscape(_ landscape: [Acre : AcreType]) {
    let maxRow = landscape.max { $0.key.row < $1.key.row }!.key.row
    let maxCol = landscape.max { $0.key.col < $1.key.col }!.key.col

    for row in 0...maxRow {
        for col in 0...maxCol {
            print(landscape[Acre(row, col)]!.rawValue, terminator: "")
        }
        print()
    }

    print()
}

func getAdjacents(forAcre acre: Acre, inLandscape landscape: [Acre : AcreType]) -> [Acre] {
    var result: [Acre] = []
    let row = acre.row
    let col = acre.col

    if landscape[Acre(row - 1, col - 1)] != nil { result.append(Acre(row - 1, col - 1))}
    if landscape[Acre(row - 1, col)] != nil { result.append(Acre(row - 1, col))}
    if landscape[Acre(row - 1, col + 1)] != nil { result.append(Acre(row - 1, col + 1))}
    if landscape[Acre(row, col - 1)] != nil { result.append(Acre(row, col - 1))}
    if landscape[Acre(row, col + 1)] != nil { result.append(Acre(row, col + 1))}
    if landscape[Acre(row + 1, col - 1)] != nil { result.append(Acre(row + 1, col - 1))}
    if landscape[Acre(row + 1, col)] != nil { result.append(Acre(row + 1, col))}
    if landscape[Acre(row + 1, col + 1)] != nil { result.append(Acre(row + 1, col + 1))}

    return result
}

let input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 18/day18.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

var landscape: [Acre : AcreType] = [:]

for (row, line) in input.enumerated() {
    for (col, acreType) in line.enumerated() {
        let acre = Acre(row, col)
        landscape[acre] = AcreType(rawValue: String(acreType))
    }
}

for minute in 1...10000 {
    var copy: [Acre : AcreType] = landscape

    for (acre, acreType) in copy {
        let adjacents = getAdjacents(forAcre: acre, inLandscape: copy)

        let treeCount = adjacents.filter() { copy[$0] == .trees }.count
        let lumberYardCount = adjacents.filter() { copy[$0] == .lumberYard }.count

        //        print("\(acre) - trees: \(treeCount) - lumber: \(lumberYardCount)")

        if acreType == .open {
            if treeCount >= 3 {
                landscape[acre] = .trees
            } else {
                landscape[acre] = acreType
            }
        }
        else if acreType == .trees {
            if lumberYardCount >= 3 {
                landscape[acre] = .lumberYard
            }
            else {
                landscape[acre] = acreType
            }
        }
        else if acreType == .lumberYard {
            if lumberYardCount >= 1 && treeCount >= 1 {
                landscape[acre] = .lumberYard
            } else {
                landscape[acre] = .open
            }
        }
    }

    if minute % 1000 == 0 {
        let woodedCount = landscape.filter { $0.value == .trees }.count
        let lumberYardCount = landscape.filter { $0.value == .lumberYard }.count

        print("\(minute): \(woodedCount * lumberYardCount)")
    }
}
