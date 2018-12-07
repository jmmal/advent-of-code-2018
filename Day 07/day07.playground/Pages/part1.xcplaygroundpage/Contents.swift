import Foundation

class Node {
    var waitingOnNodes: Set<String>
    var dependentNodes: Set<String>
    let stepName: String

    init(withName name: String) {
        self.stepName = name
        waitingOnNodes = []
        dependentNodes = []
    }
}

var input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 07/day07.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

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

var visitOrder = ""
while !nodes.isEmpty {
    let possibleNodes = nodes.filter { (node) -> Bool in
        node.value.waitingOnNodes.count == 0
    }

    let nextNode = possibleNodes.min { (node1, node2) -> Bool in
        node1.value.stepName < node2.value.stepName
    }

    if let nextNode = nextNode?.value {
        visitOrder.append(nextNode.stepName)
        nextNode.dependentNodes.forEach { (step) in
            nodes[step]?.waitingOnNodes.remove(nextNode.stepName)
        }
        nodes.removeValue(forKey: nextNode.stepName)
    }
}

print(visitOrder)
