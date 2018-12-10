#!/usr/bin/swift
import Foundation

class Marble {
    let number: Int
    var left: Marble?
    var right: Marble?

    init(_ number: Int) {
        self.number = number
    }

    static func != (lhs: Marble, rhs: Marble) -> Bool {
        return lhs.number != rhs.number
    }

    func insert(_ newMarble: Marble, nextToCurrentMarble current: Marble) {
        let marbleLeftOfInsert = current.right
        let marbleRightOfInsert = marbleLeftOfInsert!.right

        marbleLeftOfInsert!.right = newMarble
        marbleRightOfInsert!.left = newMarble

        newMarble.left = marbleLeftOfInsert
        newMarble.right = marbleRightOfInsert
    }

    static func remove(forCurrentMarble marble: Marble) -> (newCurrent: Marble, removedValue: Int) {
        var toRemove = marble

        for _ in 0..<7 {
            toRemove = toRemove.left!
        }

        let newCurrent = toRemove.right!
        newCurrent.left = toRemove.left!
        newCurrent.left?.right = newCurrent

        return (newCurrent, toRemove.number)
    }
}

let numberOfPlayers = 448
let lastMarblePoints = 7162800

var currentMarble = Marble(0)
currentMarble.left = currentMarble
currentMarble.right = currentMarble

var playerNumber = 0

var playerScores: [ Int : Int ] = [ 0 : 0 ]
var maxScore = 0

for marbleNumber in 1...lastMarblePoints {
    if marbleNumber % 23 == 0 {
        playerScores[playerNumber, default: 0] += marbleNumber

        let removeResult = Marble.remove(forCurrentMarble: currentMarble)

        playerScores[playerNumber, default: 0] += removeResult.removedValue
        currentMarble = removeResult.newCurrent
    } else {
        let newMarble = Marble(marbleNumber)
        currentMarble.insert(newMarble, nextToCurrentMarble: currentMarble)
        currentMarble = newMarble
    }

    playerNumber = (playerNumber + 1) % numberOfPlayers
}

let highestScore = playerScores.max { $0.value < $1.value }

print(highestScore!.value)



