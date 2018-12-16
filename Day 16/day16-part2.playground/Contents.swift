import Foundation

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

let input1 = try String(contentsOfFile: path).trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

var beforeRegisters: [Int] = []
var afterRegisters: [Int] = []
var instruction: [Int] = []
var sampleCount = 0

var opcodes: [Int: ([Int], [Int]) -> [Int]] = [:]
var functions: [([Int], [Int]) -> [Int]] = [addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr]

// Populates the dictionary with the opcode value and its relevant function
while opcodes.count < 16 {
    for (lineNumber, line) in input1.enumerated() {
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
            var matchingInstructions: [([Int], [Int]) -> [Int]] = []
            var matchingInstructionIndex: [Int] = []

            for (instructionIndex, function) in functions.enumerated() {
                let result = function(instruction, beforeRegisters)

                if result == afterRegisters {
                    matchingInstructions.append(function)
                    matchingInstructionIndex.append(instructionIndex)
                }
            }

            if matchingInstructions.count == 1 {
                opcodes[instruction[0]] = matchingInstructions.first!
                functions.remove(at: matchingInstructionIndex.first!)
            }
        }
    }
}

// Second part of input
let input2 = Bundle.main.path(forResource: "input2", ofType: "txt")

let program = try String(contentsOfFile: input2!).trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

var registers = [0, 0, 0, 0]

for line in program {
    let numbers = line.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap { Int(String($0)) }
    let function = opcodes[numbers[0]]!

    registers = function(numbers, registers)
}

print(registers)
