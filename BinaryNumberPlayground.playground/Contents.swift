import UIKit

var binaryNumbers = [[Int]]()
var binaryNumber = [Int]()

func generateBinaryNumber(_ n: Int) -> [[Int]] {
    if n == 0 { return [] }

    func traverse(_ n: Int) {
        if n == 0 {
            binaryNumbers.append(binaryNumber)
            return
        }

        for i in 0..<2 {
            binaryNumber.append(i)
            traverse(n-1)
            binaryNumber.removeLast()
        }
    }
    traverse(n)
    return binaryNumbers
}

let n = 3
let result = generateBinaryNumber(3)
print(result)
