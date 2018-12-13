#!/usr/bin/swift
import Foundation

enum Direction: String {
    case up = "^"
    case right = ">"
    case down = "v"
    case left = "<"
}

enum TurnDirection {
    case left
    case straight
    case right
}

class Cart: Hashable {
    var row: Int
    var col: Int

    var currentDirection: Direction
    var nextTurn: TurnDirection = .left

    init(_ row: Int, _ col: Int, _ currentDirection: Direction) {
        self.row = row
        self.col = col
        self.currentDirection = currentDirection
    }

    static func == (lhs: Cart, rhs: Cart) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }

    func takeTurn() {
        switch nextTurn {
        case .left:
            switch currentDirection {
            case .up:
                col -= 1
                currentDirection = .left
            case .left:
                row += 1
                currentDirection = .down
            case .right:
                row -= 1
                currentDirection = .up
            case .down:
                col += 1
                currentDirection = .right
            }
            nextTurn = .straight
            return
        case .straight:
            switch currentDirection {
            case .up:
                row -= 1
            case .left:
                col -= 1
            case .right:
                col += 1
            case .down:
                row += 1
            }
            nextTurn = .right
            return
        case .right:
            switch currentDirection {
            case .up:
                col += 1
                currentDirection = .right
            case .left:
                row -= 1
                currentDirection = .up
            case .right:
                row += 1
                currentDirection = .down
            case .down:
                col -= 1
                currentDirection = .left
            }
            nextTurn = .left
            return
        }
    }

    func moveStraight() {
        switch currentDirection {
        case .up:
            row -= 1
        case .down:
            row += 1
        case .left:
            col -= 1
        case .right:
            col += 1
        }
    }

    func takeCurve(_ curve: Character) {
        if curve == "/" {
            switch currentDirection {
            case .down:
                col -= 1
                currentDirection = .left
                break
            case .right:
                row -= 1
                currentDirection = .up
                break
            case .left:
                row += 1
                currentDirection = .down
                break
            case .up:
                col += 1
                currentDirection = .right
                break
            }
        }

        else if curve == "\\" {
            switch currentDirection {
            case .down:
                col += 1
                currentDirection = .right
                break
            case .right:
                row += 1
                currentDirection = .down
                break
            case .left:
                row -= 1
                currentDirection = .up
                break
            case .up:
                col -= 1
                currentDirection = .left
                break
            }
        }
    }

    func tick(atLocation location: Character) {
        if location == "-" || location == "|" {
            self.moveStraight()
        }

        else if location == "+" {
            self.takeTurn()
        }

        else if location == "/" || location == "\\" {
            self.takeCurve(location)
        }
    }
}

let input = try String(contentsOfFile: "input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

var track = input.map { Array($0) }
var carts: Set<Cart> = []

for row in 0..<track.count {
    for col in 0..<track[row].count {
        let char = track[row][col]

        if char == "<"     {
            carts.insert(Cart(row, col, .left))
            track[row][col] = "-"
        }
        else if char == ">" {
            carts.insert(Cart(row, col, .right))
            track[row][col] = "-"
        }
        else if char == "^" {
            carts.insert(Cart(row, col, .up))
            track[row][col] = "|"
        }
        else if char == "v" {
            carts.insert(Cart(row, col, .down))
            track[row][col] = "|"
        }
    }
}

var initalCartSize = carts.count

while carts.count == initalCartSize {
    // Gets the carts from top to bottom, left to right
    let sortedCarts = carts.sorted { (cart1, cart2) -> Bool in
        if cart1.row == cart2.row {
            return cart1.col < cart2.col
        }

        return cart1.row < cart2.row
    }

    for nextCart in sortedCarts {
        if let cart = carts.remove(nextCart) {
            cart.tick(atLocation: track[cart.row][cart.col])

            if let cartExists = carts.remove(cart) {
                print("\(cartExists.col),\(cartExists.row)")
            } else {
                carts.insert(cart)
            }
        }
    }
}
