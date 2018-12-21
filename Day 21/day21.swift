#!/usr/bin/swift
import Foundation
import Darwin

struct Instruction {
    let name: String
    let registers: [Int]
}

var repeated: Set<Int> = []
var last: Int?
var first: Int?

let chars = ["A", "B", "C", "D", "E", "F", "G"]
func addr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = registers[instruction[1]]

    var result = registers
    result[instruction[2]] = a + b
    return result
}

func addi(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = instruction[1]

    var result = registers
    result[instruction[2]] = a + b
    return result
}

func mulr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = registers[instruction[1]]

    var result = registers
    result[instruction[2]] = a * b
    return result
}

func muli(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = instruction[1]

    var result = registers
    result[instruction[2]] = a * b
    return result
}

func banr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = registers[instruction[1]]

    var result = registers
    result[instruction[2]] = a & b
    return result
}

func bani(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = instruction[1]

    var result = registers
    result[instruction[2]] = a & b
    return result
}

func borr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = registers[instruction[1]]

    var result = registers
    result[instruction[2]] = a | b
    return result
}

func bori(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = instruction[1]

    var result = registers
    result[instruction[2]] = a | b
    return result
}

func setr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]

    var result = registers
    result[instruction[2]] = a
    return result
}

func seti(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = instruction[0]

    var result = registers
    result[instruction[2]] = a
    return result
}

func gtir(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = instruction[0]
    let b = registers[instruction[1]]

    var result = registers

    result[instruction[2]] = a > b ? 1 : 0
    return result
}

func gtri(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = instruction[1]

    var result = registers

    result[instruction[2]] = a > b ? 1 : 0
    return result
}

func gtrr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = registers[instruction[1]]

    var result = registers

    result[instruction[2]] = a > b ? 1 : 0
    return result
}

func eqir(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = instruction[0]
    let b = registers[instruction[1]]

    var result = registers

    result[instruction[2]] = a == b ? 1 : 0
    return result
}

func eqri(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    let a = registers[instruction[0]]
    let b = instruction[1]

    var result = registers

    result[instruction[2]] = a == b ? 1 : 0
    return result
}

func eqrr(_ instruction: [Int], _ registers: [Int]) -> [Int] {
    if instruction[1] == 0 {
        if repeated.contains(registers[instruction[0]]) {
            print("Part 1: \(first!)")
            print("Part 2: \(last!)")
            exit(0)
        } else {
            repeated.insert(registers[instruction[0]])
            last = registers[instruction[0]]
        }

        if first == nil {
            first = last
        }
    }
    let a = registers[instruction[0]]
    let b = registers[instruction[1]]

    var result = registers

    result[instruction[2]] = a == b ? 1 : 0
    return result
}

func decodeInstruction(_ string: String) -> (name: String, registers: [Int]) {
    var split = string.components(separatedBy: " ")
    let instructionName = split.removeFirst()
    let instructionRegisters = split.compactMap { Int($0)! }

    return (instructionName, instructionRegisters)
}

var input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 21/day21.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

var instructionPointerIndex = Int(input.removeFirst().components(separatedBy: CharacterSet.decimalDigits.inverted)[4])!

let initialValue = 0
var registers: [Int] = [initialValue, 0, 0, 0, 0, 0]
var instructions: [Int : Instruction] = [:]
for (instructionNumber, string) in input.enumerated() {
    let (name, registers) = decodeInstruction(string)
    instructions[instructionNumber] = Instruction(name: name, registers: registers)
}

while registers[instructionPointerIndex] < instructions.count {
    let instruction = instructions[registers[instructionPointerIndex]]!

    switch instruction.name {
    case "addr":
        registers = addr(instruction.registers, registers)
        break
    case "addi":
        registers = addi(instruction.registers, registers)
        break
    case "mulr":
        registers = mulr(instruction.registers, registers)
        break
    case "muli":
        registers = muli(instruction.registers, registers)
        break
    case "banr":
        registers = banr(instruction.registers, registers)
        break
    case "bani":
        registers = bani(instruction.registers, registers)
        break
    case "borr":
        registers = borr(instruction.registers, registers)
        break
    case "bori":
        registers = bori(instruction.registers, registers)
        break
    case "setr":
        registers = setr(instruction.registers, registers)
        break
    case "seti":
        registers = seti(instruction.registers, registers)
        break
    case "gtir":
        registers = gtir(instruction.registers, registers)
        break
    case "gtri":
        registers = gtri(instruction.registers, registers)
        break
    case "gtrr":
        registers = gtrr(instruction.registers, registers)
        break
    case "eqir":
        registers = eqir(instruction.registers, registers)
        break
    case "eqri":
        registers = eqri(instruction.registers, registers)
        break
    case "eqrr":
        registers = eqrr(instruction.registers, registers)
        break
    default:
        break
    }

    registers[instructionPointerIndex] += 1
}
