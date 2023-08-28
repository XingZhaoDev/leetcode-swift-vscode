struct Stack<T> {
    private var elements: [T] = []

    var isEmpty: Bool { elements.isEmpty }
    var count: Int { elements.count }

    mutating func push(_ element: T) {
        elements.append(element)
    }

    mutating func pop() -> T? {
        guard !isEmpty else { return nil }
        return elements.removeLast()
    } 

    func peek() -> T? {
        elements.last
    }
}

var stack = Stack<Int>()

for i in 0 ..< 10 {
    stack.push(i)
}

let candidate = stack.pop()
print("poped candidate \(candidate)")
print(stack.count)
let peekElement = stack.peek()
print("peek candidate \(peekElement)")