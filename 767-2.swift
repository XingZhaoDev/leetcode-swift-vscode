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
        guard !s.isEmpty else { return s }
        let s = Array(s)
        var dict: [Character: Int] = s.reduce(into: [Character: Int]()) { 
            $0[$1, default: 0] += 1
        }
        var heap = Heap<Item>(>)
        for (char, freq) in dict {
            heap.insert(Item(char: char, frequency: freq))
        }
        var result = ""
        var prevItem: Item?

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
    private var comparator: (T, T) -> Bool

    init(_ comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
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
            if(comparator(value, elements[parent])) {
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
            if (rightIndex < count) && comparator(elements[rightIndex], elements[childIndex]) {
                   childIndex = rightIndex
            }
            if comparator(elements[childIndex], value) {
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