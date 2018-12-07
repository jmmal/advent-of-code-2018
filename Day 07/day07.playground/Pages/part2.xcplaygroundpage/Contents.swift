//: [Previous](@previous)

import Foundation

class Node {
    var waitingOnNodes: Set<String>
    var dependentNodes: Set<String>
    let stepName: String
    var timeRemaining: Int = 0

    init(withName name: String) {
        self.stepName = name
        waitingOnNodes = []
        dependentNodes = []

        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let index = letters.firstIndex(of: Character(name))
        timeRemaining = CharacterSet.uppercaseLetters.description.distance(from: letters.startIndex, to: index!) + 61
    }
}

var input = try String(contentsOfFile: "/Users/josh/Library/Autosave Information/day07-part2.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

var nodes: [String : Node] = [:]

for step in input {
    let arr = step.components(separatedBy: .whitespaces)

    let awaitingNode = nodes[arr[7], default: Node(withName: arr[7])]
    let precedingNode = nodes[arr[1], default: Node(withName: arr[1])]

    awaitingNode.waitingOnNodes.insert(precedingNode.stepName)
    precedingNode.dependentNodes.insert(awaitingNode.stepName)

    nodes[arr[7]] = awaitingNode
    nodes[arr[1]] = precedingNode
}

var seconds = 0
let totalWorkers = 5
var nodesInProgress: Set<String> = []

while !nodes.isEmpty {
    // All nodes that could be worked on
    var sortedNodes = nodes.filter { (node) -> Bool in
        node.value.waitingOnNodes.count == 0
        }.keys.sorted(by: { $0 > $1 })

    // while there is free workers
    while nodesInProgress.count < totalWorkers && !sortedNodes.isEmpty {
        nodesInProgress.insert(sortedNodes.popLast()!)
    }

    nodesInProgress.forEach{ (step) in
        let node = nodes[step]!

        node.timeRemaining -= 1
        if node.timeRemaining == 0 {
            node.dependentNodes.forEach { (step) in
                nodes[step]?.waitingOnNodes.remove(node.stepName)
            }
            nodes.removeValue(forKey: node.stepName)
            nodesInProgress.remove(step)
        }
    }

    seconds += 1
}

print(seconds)


//: [Next](@next)
