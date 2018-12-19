#!/usr/bin/swift
import Foundation

struct Instruction {
    let name: String
    let registers: [Int]
}

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

var input = try String(contentsOfFile: "/Users/josh/Development/advent-of-code-2018/Day 19/day19.playground/Resources/input.txt").trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

var instructionPointerIndex = Int(input.removeFirst().components(separatedBy: CharacterSet.decimalDigits.inverted)[4])!

var registers: [Int] = [1, 0, 0, 0, 0, 0]
var instructions: [Int : Instruction] = [:]
for (instructionNumber, string) in input.enumerated() {
    let (name, registers) = decodeInstruction(string)
    instructions[instructionNumber] = Instruction(name: name, registers: registers)
}

for _ in 1...100 {
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

// Calculates the sum of prime factors
// Inspired by Reddit and https://www.geeksforgeeks.org/print-all-prime-factors-of-a-given-number/
var n = registers[5]
var sum = 1 + n

for i in stride(from: 3, to: Int(sqrt(Double(n))) + 2, by: 2)  {
    while n % i == 0 {
        sum += i
        n = n/i
    }
}

if n > 2 {
    sum += n
}

print(sum)


