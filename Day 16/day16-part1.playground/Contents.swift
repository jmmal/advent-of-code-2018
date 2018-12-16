import UIKit

func addr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = registers[instruction[2]]

    var result = registers
    result[instruction[3]] = a + b
    return result
}

func addi(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = instruction[2]

    var result = registers
    result[instruction[3]] = a + b
    return result
}

func mulr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = registers[instruction[2]]

    var result = registers
    result[instruction[3]] = a * b
    return result
}

func muli(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = instruction[2]

    var result = registers
    result[instruction[3]] = a * b
    return result
}

func banr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = registers[instruction[2]]

    var result = registers
    result[instruction[3]] = a & b
    return result
}

func bani(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = instruction[2]

    var result = registers
    result[instruction[3]] = a & b
    return result
}

func borr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = registers[instruction[2]]

    var result = registers
    result[instruction[3]] = a | b
    return result
}

func bori(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = instruction[2]

    var result = registers
    result[instruction[3]] = a | b
    return result
}

func setr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]

    var result = registers
    result[instruction[3]] = a
    return result
}

func seti(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = instruction[1]

    var result = registers
    result[instruction[3]] = a
    return result
}

func gtir(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = instruction[1]
    let b = registers[instruction[2]]

    var result = registers

    result[instruction[3]] = a > b ? 1 : 0
    return result
}

func gtri(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = instruction[2]

    var result = registers

    result[instruction[3]] = a > b ? 1 : 0
    return result
}

func gtrr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = registers[instruction[2]]

    var result = registers

    result[instruction[3]] = a > b ? 1 : 0
    return result
}

func eqir(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = instruction[1]
    let b = registers[instruction[2]]

    var result = registers

    result[instruction[3]] = a == b ? 1 : 0
    return result
}

func eqri(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = instruction[2]

    var result = registers

    result[instruction[3]] = a == b ? 1 : 0
    return result
}

func eqrr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[1]]
    let b = registers[instruction[2]]

    var result = registers

    result[instruction[3]] = a == b ? 1 : 0
    return result
}

guard let path = Bundle.main.path(forResource: "input", ofType: "txt") else {
    fatalError()
}

let input = try String(contentsOfFile: path).components(separatedBy: .newlines)

var beforeRegisters: [Int] = []
var afterRegisters: [Int] = []
var instruction: [Int] = []
var sampleCount = 0

var functions: [([Int], [Int]) -> [Int]] = [addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr]

for (lineNumber, line) in input.enumerated() {
    let numbers = line.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap { Int(String($0)) }

    if lineNumber % 4 == 0 {
        beforeRegisters = numbers
    }
    else if lineNumber % 4 == 1 {
        instruction = numbers
    }
    else if lineNumber % 4 == 2 {
        afterRegisters = numbers
    }
    else {
        var instructionCount = 0
        for function in functions {
            let result = function(instruction, beforeRegisters)

            if result == afterRegisters {
                instructionCount += 1
            }
        }

        if instructionCount >= 3 {
            sampleCount += 1
        }
    }
}

print(sampleCount)
