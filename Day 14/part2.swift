#!/usr/bin/swift
import Foundation

class Elf {
    var recipeNumber: Int

    init(_ location: Int) {
        recipeNumber = location
    }

    func nextRecipe(fromRecipes recipes: [Int]) {
        recipeNumber = (recipeNumber + recipes[recipeNumber] + 1) % (recipes.count)
    }
}

var elfs = [Elf(0), Elf(1)]

var recipeScores: [Int] = [3, 7]
var recipesString: String = Array(recipeScores).map{ String($0) }.joined()

var input = 598701
var inputArray = String(input).compactMap { Int(String($0)) }

while true {
    let newRecipe = String(recipeScores[elfs[0].recipeNumber] + recipeScores[elfs[1].recipeNumber])
    let array = newRecipe.compactMap { Int(String($0)) }

    recipeScores.append(contentsOf: array)
    recipesString.append(contentsOf: newRecipe)

    elfs[0].nextRecipe(fromRecipes: recipeScores)
    elfs[1].nextRecipe(fromRecipes: recipeScores)

    if recipeScores.count > inputArray.count {
        let leftWindowLeftIndex = recipeScores.count - inputArray.count - 1
        let leftWindowRightIndex = recipeScores.count - 1

        let rightWindowLeftIndex = recipeScores.count - inputArray.count
        let rightWindowRightIndex = recipeScores.count

        let leftWindow = Array(recipeScores[leftWindowLeftIndex..<leftWindowRightIndex])
        let rightWindow = Array(recipeScores[rightWindowLeftIndex..<rightWindowRightIndex])

        if leftWindow == inputArray {
            print("Found at \(inputArray): \(leftWindowLeftIndex)")
            break
        }

        if rightWindow == inputArray {
            print("Found \(inputArray) at: \(rightWindowLeftIndex)")
            break
        }
    }
}

