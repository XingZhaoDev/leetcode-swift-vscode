/*
767. Reorganize String
Given a string s, rearrange the characters of s so that any two adjacent characters are not the same.

Return any possible rearrangement of s or return "" if not possible.
Example 1:

Input: s = "aab"
Output: "aba"
Example 2:

Input: s = "aaab"
Output: ""
 

Constraints:

1 <= s.length <= 500
s consists of lowercase English letters.
*/

class Solution {
    struct Item: Comparable {
        let char: Character
        var frequency: Int

        static func <(lhs: Item, rhs: Item) -> Bool {
            if lhs.frequency == rhs.frequency { return lhs.char > rhs.char }
            return lhs.frequency < rhs.frequency
        }
    }

    func reorganizeString(_ s: String) -> String {
        let dict = s.reduce(into: [Character: Int]()) { $0[$1, default: 0] += 1 }
        var heap = Heap<Item>(>)
        for (char, freq) in dict {
            let item = Item(char: char, frequency: freq)
            heap.insert(item)
        }
        print(heap)

        var prevItem: Item?
        var result = ""

        while !heap.isEmpty {
            guard var topItem = heap.remove() else { break }
            if let prevItem = prevItem, prevItem.frequency > 0 {
                heap.insert(prevItem)
            }
            result.append(topItem.char)
            topItem.frequency -= 1
            prevItem = topItem
        }
        return result.count == s.count ? result : ""
    }
}

struct Heap<T: Comparable> {
    private var elements: [T] = []
    private let comparator: (T, T) -> Bool

    init(_ comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
    }

    var isEmpty: Bool { elements.isEmpty }
    var count: Int { elements.count }

    private func leftChildIndex(ofParent index: Int) -> Int {
        2 * index + 1
    }

    private func rightChildIndex(ofParent index: Int) -> Int {
        2 * index + 2
    }

    private func parentIndex(ofChild index: Int) -> Int {
        (index - 1) / 2
    }

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
        while i > 0 {
            let parentIdx = parentIndex(ofChild: i)
            if comparator(elements[i], elements[parentIdx]) {
                elements.swapAt(i, parentIdx)
                i = parentIdx
            } else { 
                break
            }
        }
    }

    mutating func bubbleDown(_ index: Int) {
        var index = index
        while rightChildIndex(ofParent: index) < count {
            let leftIdx = leftChildIndex(ofParent: index)
            let rightIdx = rightChildIndex(ofParent: index)
            let childIdx = comparator(elements[leftIdx], elements[rightIdx]) ? leftIdx : rightIdx
            if comparator(elements[childIdx], elements[index]) {
                elements.swapAt(index, childIdx)
                index = childIdx
            } else {
                break
            }
        }
    }
}

// DP?
// Greedy?
// Two pointers
// HashMap
// HEAP