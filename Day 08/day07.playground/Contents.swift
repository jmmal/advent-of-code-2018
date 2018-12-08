import UIKit

class Node {
    var metadata: [Int] = []
    var childNodes: [Node] = []
}

let input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 08/part1.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .whitespaces)

let integers = input.compactMap { Int($0) }
var sum = 0

func readNode(_ integers: [Int], atIndex index: inout Int) -> Node {
    var numberOfChildNodes = integers[index]
    var numberOfMetadataEntries = integers[index + 1]

    let node = Node()
    index += 2

    while numberOfChildNodes > 0 {
        node.childNodes.append(readNode(integers, atIndex: &index))
        numberOfChildNodes -= 1
    }

    while numberOfMetadataEntries > 0 {
        node.metadata.append(integers[index])
        sum += integers[index]
        index += 1
        numberOfMetadataEntries -= 1
    }

    return node
}

func calculateNodeValue(forNode node: Node) -> Int {
    if node.childNodes.count == 0 {
        return node.metadata.reduce(0, +)
    } else {
        var value = 0
        for entry in node.metadata where entry <= node.childNodes.count {
            value += calculateNodeValue(forNode: node.childNodes[entry - 1])
        }

        return value
    }
}

var index = 0
let rootNode = readNode(integers, atIndex: &index)
print("Part 1: \(sum)")

let value = calculateNodeValue(forNode: rootNode)
print("Part 2: \(value)")
