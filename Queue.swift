// First in, First out
struct Queue<T> {
    private var elements: [T] = []
    
    var isEmpty: Bool { elements.isEmpty }
    var count: Int { elements.count }

    mutating func enqueue(_ element: T) {
        elements.append(element)
    }

    mutating func dequeue() -> T? {
        guard !isEmpty else { return nil }
        return elements.removeFirst()
    }

    func peek() -> T? {
        elements.first
    }
}

var queue = Queue<Int>()
for i in 0 ..< 10 {
    queue.enqueue(i)
}

let candidate = queue.dequeue()
let peekElement = queue.peek()
print("pop candidate \(candidate)")
print(queue.count)
print("peek candidate \(peekElement)")