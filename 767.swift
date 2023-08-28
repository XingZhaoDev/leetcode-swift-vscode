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

    public func reorganizeString(_ s: String) -> String {
        let dict = s.reduce(into: [Character: Int]()) { $0[$1, default: 0] += 1 }
        var heap = Heap<Item>(>)
        for (char, freq) in dict {
            let item = Item(char: char, frequency: freq)
            heap.insert(item)
        }
        var prevItem: Item?
        var result = ""

        while !heap.isEmpty {
            guard var topItem = heap.remove() else { break }
            //print("peek item is \(topItem)")
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

/*
struct Heap<T: Comparable> {
    private var elements: [T] = []
    private let comparator: (T, T) -> Bool

    init(_ comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
    }

    var isEmpty: Bool { elements.isEmpty }
    var count: Int { elements.count }

    func print() {
        for element in elements {
            dump(element)
        }
    }
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
        let parentIdx = parentIndex(ofChild: i)
        while i > 0 && comparator(elements[i], elements[parentIdx]) {
             elements.swapAt(i, parentIdx)
             i = parentIdx
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
}*/

/*
struct Heap<T: Comparable> {
    private var heap = [T]()
    private let comparator: (T, T)->Bool 
    
    init(_ comparator: @escaping (T, T)->Bool) {
        self.comparator = comparator
    }
    
    subscript(i: Int) -> T { heap[i] }
    var isEmpty: Bool { heap.isEmpty }
    var count: Int { heap.count }
    
    mutating func insert(_ val: T) {
        heap.append(val)
        bubbleUp(count - 1)
    }
    
    func parentIndex(ofChild index: Int) -> Int {
        (index - 1) / 2
    }

    mutating func bubbleUp(_ index: Int) {
        var pos = index
        
        // MaxHeap: if current value is greater than parent, then swap the values
        // MinHeap: if current value is less than parent, then swap the values
        while pos > 0 && comparator(heap[pos], heap[(pos-1)/2]) {
            heap.swapAt(pos, (pos-1)/2)
            pos = (pos-1)/2
        }
    }

    mutating func remove() -> T? {
        /*
       // guard let ans = heap.first else {return nil }
        //heap[0] = heap.last!
        guard !isEmpty else { return nil }
        guard count > 1 else { return heap.removeLast() }
        heap.swapAt(0, count - 1)
        let value = heap.removeLast()

        var pos = 0
        while pos*2 + 2 < heap.count {
            let swapSonInd = 
                comparator(heap[pos*2 + 1], heap[pos*2 + 2]) ?
                (pos*2 + 1) : (pos*2 + 2)
            if comparator(heap[pos], heap[swapSonInd]) {
                heap.swapAt(pos, swapSonInd)
                pos = swapSonInd
            } else {
                break
            }
        }
       // let last = heap.popLast()
        return value*/
        guard !isEmpty else { return nil }
        
        if count == 1 {
            return heap.removeLast()
        } else {
            // Use the last node to replace the first one, then fix the heap by
            // shifting this new first node into its proper position.
            let value = heap[0]
            heap[0] = nodes.removeLast()
            bubbleDown(0)
            return value
        }
    }
}*/

/*
import Foundation

public struct Heap<T> {
    
    /** The array that stores the heap's nodes. */
    var nodes = [T]()
    
    /**
     * Determines how to compare two nodes in the heap.
     * Use '>' for a max-heap or '<' for a min-heap,
     * or provide a comparing method if the heap is made
     * of custom elements, for example tuples.
     */
    private var orderCriteria: (T, T) -> Bool
    
    /**
     * Creates an empty heap.
     * The sort function determines whether this is a min-heap or max-heap.
     * For comparable data types, > makes a max-heap, < makes a min-heap.
     */
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
    }
    
    /**
     * Creates a heap from an array. The order of the array does not matter;
     * the elements are inserted into the heap in the order determined by the
     * sort function. For comparable data types, '>' makes a max-heap,
     * '<' makes a min-heap.
     */
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeap(from: array)
    }
    
    /**
     * Configures the max-heap or min-heap from an array, in a bottom-up manner.
     * Performance: This runs pretty much in O(n).
     */
    private mutating func configureHeap(from array: [T]) {
        nodes = array
        for i in stride(from: (nodes.count/2-1), through: 0, by: -1) {
            shiftDown(i)
        }
    }
    
    public var isEmpty: Bool {
        return nodes.isEmpty
    }
    
    public var count: Int {
        return nodes.count
    }
    
    /**
     * Returns the index of the parent of the element at index i.
     * The element at index 0 is the root of the tree and has no parent.
     */
    @inline(__always) internal func parentIndex(ofIndex i: Int) -> Int {
        return (i - 1) / 2
    }
    
    /**
     * Returns the index of the left child of the element at index i.
     * Note that this index can be greater than the heap size, in which case
     * there is no left child.
     */
    @inline(__always) internal func leftChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 1
    }
    
    /**
     * Returns the index of the right child of the element at index i.
     * Note that this index can be greater than the heap size, in which case
     * there is no right child.
     */
    @inline(__always) internal func rightChildIndex(ofIndex i: Int) -> Int {
        return 2*i + 2
    }
    
    /**
     * Returns the maximum value in the heap (for a max-heap) or the minimum
     * value (for a min-heap).
     */
    public func peek() -> T? {
        return nodes.first
    }
    
    /**
     * Adds a new value to the heap. This reorders the heap so that the max-heap
     * or min-heap property still holds. Performance: O(log n).
     */
    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }
    
    /**
     * Adds a sequence of values to the heap. This reorders the heap so that
     * the max-heap or min-heap property still holds. Performance: O(log n).
     */
    public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for value in sequence {
            insert(value)
        }
    }
    
    /**
     * Allows you to change an element. This reorders the heap so that
     * the max-heap or min-heap property still holds.
     */
    public mutating func replace(index i: Int, value: T) {
        guard i < nodes.count else { return }
        
        remove(at: i)
        insert(value)
    }
    
    /**
     * Removes the root node from the heap. For a max-heap, this is the maximum
     * value; for a min-heap it is the minimum value. Performance: O(log n).
     */
    @discardableResult public mutating func remove() -> T? {
        guard !nodes.isEmpty else { return nil }
        
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            // Use the last node to replace the first one, then fix the heap by
            // shifting this new first node into its proper position.
            let value = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(0)
            return value
        }
    }
    
    /**
     * Removes an arbitrary node from the heap. Performance: O(log n).
     * Note that you need to know the node's index.
     */
    @discardableResult public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else { return nil }
        
        let size = nodes.count - 1
        if index != size {
            nodes.swapAt(index, size)
            shiftDown(from: index, until: size)
            shiftUp(index)
        }
        return nodes.removeLast()
    }
    
//   public mutating func removeValue(_ value: T) -> T? {
//        var targetIndex = -1
//        for (index, node) in nodes.enumerated() {
//            if node == value {
//                targetIndex = index
//                break
//            }
//        }
//
//        if targetIndex == -1 { return nil }
//
//        return remove(at: targetIndex)
//    }
    /**
     * Takes a child node and looks at its parents; if a parent is not larger
     * (max-heap) or not smaller (min-heap) than the child, we exchange them.
     */
    internal mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
            nodes[childIndex] = nodes[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        
        nodes[childIndex] = child
    }
    
    /**
     * Looks at a parent node and makes sure it is still larger (max-heap) or
     * smaller (min-heap) than its childeren.
     */
    internal mutating func shiftDown(from index: Int, until endIndex: Int) {
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = leftChildIndex + 1
        
        // Figure out which comes first if we order them by the sort function:
        // the parent, the left child, or the right child. If the parent comes
        // first, we're done. If not, that element is out-of-place and we make
        // it "float down" the tree until the heap property is restored.
        var first = index
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
            first = leftChildIndex
        }
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
            first = rightChildIndex
        }
        if first == index { return }
        
        nodes.swapAt(index, first)
        shiftDown(from: first, until: endIndex)
    }
    
    internal mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
    
}*/

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

let s = "aabbccdd"
let solution = Solution()
let result = solution.reorganizeString(s)
print("solution result is \(result)")
// DP?
// Greedy?
// Two pointers
// HashMap
// HEAP
