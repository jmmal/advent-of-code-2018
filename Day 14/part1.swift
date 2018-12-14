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

var rounds = 598701

while recipeScores.count < rounds + 10 {
    let newRecipe = String(recipeScores[elfs[0].recipeNumber] + recipeScores[elfs[1].recipeNumber])
    let array = newRecipe.compactMap { Int(String($0)) }
    recipeScores.append(contentsOf: array)

    elfs[0].nextRecipe(fromRecipes: recipeScores)
    elfs[1].nextRecipe(fromRecipes: recipeScores)
}

let result = Array(recipeScores[rounds..<rounds+10]).map { String($0) }.joined()
print(result)





