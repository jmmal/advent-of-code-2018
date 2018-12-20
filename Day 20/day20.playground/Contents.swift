import Foundation

struct Location: Hashable {
    let row: Int
    let col: Int

    var south: Location {
        return Location(row + 1, col)
    }

    var north: Location {
        return Location(row - 1, col)
    }

    var west: Location {
        return Location(row, col - 1)
    }

    var east: Location {
        return Location(row, col + 1)
    }

    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }

    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(col)
    }
}

func build(_ map: inout [Location : Int], _ directions: [Character], _ index: inout Int, _ currentLocation: Location) {
    var location = currentLocation
    var distance = map[currentLocation]!

    while index < directions.count - 1 {
        let direction = directions[index]

        switch direction {
        case "N":
            location = location.north
            distance += 1
            if map[location] == nil {
                map[location] = distance
            }
            break
        case "E":
            location = location.east
            distance += 1
            if map[location] == nil {
                map[location] = distance
            }
            break
        case "S":
            location = location.south
            distance += 1
            if map[location] == nil {
                map[location] = distance
            }
            break
        case "W":
            location = location.west
            distance += 1
            if map[location] == nil {
                map[location] = distance
            }
            break
        case "(":
            index += 1
            build(&map, directions, &index, location)

            while (directions[index] == "|") {
                index += 1
                build(&map, directions, &index, location)
            }
        case "|":
            return
        case ")":
            return
        default:
            fatalError("Unexpected input")
        }

        index += 1
    }
}

var input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 20/day20.playground/Resources/input.txt").trimmingCharacters(in: .newlines)

let initialLocation = Location(0, 0)

var map: [Location : Int] = [initialLocation : 0]
let directions = Array(input)

var index = 1
build(&map, directions, &index, initialLocation)

print(map.values.max())
print(map.values.filter { $0 >= 1000 }.count)
