import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class DataStream {
    private var items: [Int]
    
    init(items: [Int]) {
        self.items = items.reversed()
    }
    
    func pop() -> Int {
        return self.items.popLast() ?? 0
    }
}

class Node {
    var metadata: [Int] = []
    var children: [Node] = []
    
    convenience init(dataStream: DataStream) {
        self.init()
        
        let nChildren = dataStream.pop()
        let nMetadata = dataStream.pop()
        
        for _ in 0 ..< nChildren {
            children.append(Node(dataStream: dataStream))
        }
        
        for _ in 0 ..< nMetadata {
            metadata.append(dataStream.pop())
        }
    }
    
    func sum() -> Int {
        if children.isEmpty {
            return metadata.reduce(0, +)
        } else {
            return metadata.reduce(0, { result, index in
                result + (children[safe: index - 1]?.sum() ?? 0)
            })
        }
    }
}

func readData(filename: String) -> DataStream? {
    if let fileURL = CommandLine.arguments.first.map({ URL(fileURLWithPath: $0).deletingLastPathComponent().appendingPathComponent(filename) }),
        let data = try? Data(contentsOf: fileURL),
        let content = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
        return DataStream(items: content.components(separatedBy: " ").compactMap(Int.init))
    }
    return nil
}

func main() {
    if let data = readData(filename: "input") {
        let tree = Node(dataStream: data)
        print(tree.sum())
    }
}

main()
