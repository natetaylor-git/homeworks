import Foundation

public class ThreadSafeArray<T> {
    private let queue = DispatchQueue(label: "com.arrayQueue", attributes: .concurrent)
    private var array: [T] = []
    
    public func remove(at index: Int){
        self.queue.async(flags: .barrier) {
            self.array.remove(at: index)
        }
    }
    
    public func append(element: T) {
        self.queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }
    
    public subscript(index: Int) -> T {
        get {
            var item: T!
            // так как есть return, надо дождаться получения item, чтобы не было crash
            self.queue.sync {
                item = self.array[index]
            }
            return item
        }
        
        set (newElement) {
            queue.async(flags: .barrier) {
                self.array[index] = newElement
            }
        }
    }

}
