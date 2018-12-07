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

var input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 07/day07.playground/Pages/part1.xcplaygroundpage/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

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
    let possibleNodes = nodes.filter { $0.value.waitingOnNodes.count == 0 }
    let nextNode = possibleNodes.min { $0.value.stepName < $1.value.stepName }

    if let nextNode = nextNode?.value {
        visitOrder.append(nextNode.stepName)
        nextNode.dependentNodes.forEach { (step) in
            nodes[step]?.waitingOnNodes.remove(nextNode.stepName)
        }
        nodes.removeValue(forKey: nextNode.stepName)
    }
}

print(visitOrder)
