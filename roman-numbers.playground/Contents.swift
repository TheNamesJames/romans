/*: 
 # Romans is a programming excercise in a Swift Playground
 
 The problem is converting between [roman numerals](https://en.wikipedia.org/wiki/Roman_numerals) & western arabic numbers.
 
 Your challenge is to implement two functions
 1. romanToNum which takes Roman numbers as Strings and returns their numeric value
 2. numToRoman which takes a regular number and returns a roman one as a String

 We have provided a few tests which pass by chance and one that doesnt
 
 - Note:
 Written in the year MMXVI,
 revised in the year MMXVII
 */
import Foundation

/// Custom `assert` override. The default one crashed when running 4000-ish times
func assert(_ condition: Bool, _ message: String) {
    if condition {
        print("✅")
    } else {
        print("🛑 \(message)")
    }
}


func number(forRomanSymbol symbol: Character) -> Int {
    switch symbol {
    case "I": return 1
    case "V": return 5
    case "X": return 10
    case "L": return 50
    case "C": return 100
    case "D": return 500
    case "M": return 1000
    default: fatalError("idiot")
    }
}

func romanToNum(romanNumber: String) -> Int {
    var sum = 0
    var currentSymbolValue: Int? = nil
    var tempSum = 0
    
    for char in romanNumber.characters {
        
        let value = number(forRomanSymbol: char)
        
        if let current = currentSymbolValue, value <= current {
            sum += tempSum
            tempSum = value
            currentSymbolValue = value
        } else if let current = currentSymbolValue, value > current {
            tempSum = value - tempSum
        } else {
            currentSymbolValue = value
            tempSum += value
        }
    }
    
    sum += tempSum
    
    return sum
}

// TODO: plz refactor
func numToRoman(number: Int) -> String {
    if number >= 1000 {
        return repeatElement("M", count: number/1000).joined() + numToRoman(number: number % 1000)
    } else if number >= 900 {
        return "CM" + numToRoman(number: number - 900)
    } else if number >= 500 {
        return repeatElement("D", count: number/500).joined() + numToRoman(number: number % 500)
    } else if number >= 400 {
        return "CD" + numToRoman(number: number - 400)
    } else if number >= 100 {
        return repeatElement("C", count: number/100).joined() + numToRoman(number: number % 100)
    } else if number >= 90 {
        return "XC" + numToRoman(number: number - 90)
    } else if number >= 50 {
        return repeatElement("L", count: number/50).joined() + numToRoman(number: number % 50)
    } else if number >= 40 {
        return "XL" + numToRoman(number: number - 40)
    } else if number >= 10 {
        return repeatElement("X", count: number/10).joined() + numToRoman(number: number % 10)
    } else if number == 9 {
        return "IX"
    } else if number >= 5 {
        return repeatElement("V", count: number/5).joined() + numToRoman(number: number % 5)
    } else if number == 4 {
        return "IV"
    } else {
        return repeatElement("I", count: number).joined()
    }
}

let III = "III"
let three = 3
assert(romanToNum(romanNumber: III) == three, "the number III is 3")
assert(numToRoman(number: three) == III, "the number 3 is III")
// associative?? commutative??
assert(romanToNum(romanNumber: numToRoman(number: three)) == three, "3 -> III -> 3")
assert(numToRoman(number: romanToNum(romanNumber: III)) == III, "III -> 3 -> III")

let IV = "IV"
assert(romanToNum(romanNumber: IV) == 4, "IV should be four")

let XIX = "XIX"
assert(romanToNum(romanNumber: XIX) == 19, "XIX should be 19")



func buildTestCases() -> [Int: String] {
    guard let url = Bundle.main.url(forResource: "A Ton of Numerals", withExtension: "txt") else { return [:] }
    guard let lines = (try? String(contentsOf: url))?.components(separatedBy: .newlines) else { return [:] }
    
    var result: [Int: String] = [:]
    for (i, romanNumber) in lines.enumerated() {
        guard !romanNumber.isEmpty
            else { continue } // Ignore last (empty) newline
        
        result[i+1] = romanNumber
    }
    
    return result
}

for (number, romanNumeral) in buildTestCases() {
    let numberResult = romanToNum(romanNumber: romanNumeral)
    assert(numberResult == number, "Failed \(romanNumeral) should be \(number)")
    
    let romanResult = numToRoman(number: number)
    assert(romanResult == romanNumeral, "Failed \(romanNumeral) should be \(number)")
    
    assert(numToRoman(number: romanToNum(romanNumber: romanNumeral)) == romanNumeral, "failed commutative with \(romanNumeral)")
}

