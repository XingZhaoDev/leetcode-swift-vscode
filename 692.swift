/*
692. Top K Frequent Words

Given an array of strings words and an integer k, return the k most frequent strings.

Return the answer sorted by the frequency from highest to lowest. Sort the words with the same frequency by their lexicographical order.

 Constraints:

1 <= words.length <= 500
1 <= words[i].length <= 10
words[i] consists of lowercase English letters.
k is in the range [1, The number of unique words[i]]

Example 1:

Input: words = ["i","love","leetcode","i","love","coding"], k = 2
Output: ["i","love"]
Explanation: "i" and "love" are the two most frequent words.
Note that "i" comes before "love" due to a lower alphabetical order.
Example 2:

Input: words = ["the","day","is","sunny","the","the","the","sunny","is","is"], k = 4
Output: ["the","is","sunny","day"]
Explanation: "the", "is", "sunny" and "day" are the four most frequent words, with the number of occurrence being 4, 3, 2 and 1 respectively.
*/

struct Heap<T: Comparable> {
    private var elements: [T] = []
    private let isMaxHeap: Bool

    init(isMaxHeap: Bool = true) {
        self.isMaxHeap = isMaxHeap
    }

    var isEmpty: Bool { elements.isEmpty }
    var count: Int { elements.count }

    mutating func insert(_ element: T) {
        elements.append(element)
        bubbleUp(count - 1)
    }

    mutating func remove() -> T? {
        guard !isEmpty else { return nil }
        guard count > 1 else { return elements.removeLast() }
        elements.swapAt(0, count - 1)
        let value = elements.removeLast()
        bubbleDown(0)
        return value
    }

    mutating func bubbleUp(_ index: Int) {
        var i = index
        let value = elements[i]

        while i > 0 {
            let parent = (i-1) / 2
            if(isMaxHeap && value > elements[parent]) || (!isMaxHeap && value < elements[parent]) {
                elements[i] = elements[parent]
                i = parent
            } else {
                break
            }
        }
        elements[i] = value
    }

    mutating func bubbleDown(_ index: Int) {
        var i = index
        let value = elements[i]
        
        while 2 * i + 1 < count {
            var childIndex = 2 * i + 1
            let rightIndex = childIndex + 1
            if (rightIndex < count) && (isMaxHeap && elements[rightIndex] > elements[childIndex]) ||
                (!isMaxHeap && elements[rightIndex] < elements[childIndex]) {
                   childIndex = rightIndex
                }
            if (isMaxHeap && value < elements[childIndex]) || (!isMaxHeap && value > elements[childIndex]) {
                elements[i] = elements[childIndex]
                i = childIndex
            } else {
                break
            }
        }
        elements[i] = value
    }

    func peek() -> T? {
        elements.first
    }
}


class Solution {
    struct Word: Comparable {
        let title: String
        let frequency: Int

        static func <(lhs: Word, rhs: Word) -> Bool {
            if lhs.frequency == rhs.frequency { return lhs.title > rhs.title }
            return lhs.frequency < rhs.frequency
        }
    }

    func topKFrequent(_ words: [String], _ k: Int) -> [String] {
        guard !words.isEmpty, k > 0 else { return [] }
        var dict: [String: Int] = [:]
        for word in words {
            dict[word, default: 0] += 1
        }

        var heap = Heap<Word>()
        for (word, frequency) in dict {
            let item = Word(title: word, frequency: frequency)
            heap.insert(item)
        }
        var results: [String] = []
        for _ in 0..<k {
            if let item = heap.remove() {
                results.append(item.title)
            }
        }
        return results
    }
}


let solution = Solution()
let words = ["the","day","is","sunny","the","the","the","sunny","is","is"], k = 4
let result = solution.topKFrequent(words, k)
print("result is \(result)")