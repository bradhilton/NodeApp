import Foundation

var stateKey = 0
var parentKey = 1
var childrenKey = 2

public protocol Node : class {
    associatedtype State
    init(state: State)
    func didSet(state: State, oldValue: State)
    static func equals(lhs: State, rhs: State) -> Bool
}

extension Node {
    
    public var state: State {
        get {
            guard let state = objc_getAssociatedObject(self, &stateKey) as? State else {
                fatalError("\(self) node state uninitialized")
            }
            return state
        }
        set {
            let oldValue = objc_getAssociatedObject(self, &stateKey) as? State
            objc_setAssociatedObject(self, &stateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let oldValue = oldValue, !Self.equals(lhs: newValue, rhs: oldValue) {
                parent?(newValue)
                didSet(state: newValue, oldValue: oldValue)
                children.forEach { $0(newValue) }
            }
        }
    }
    
    private var parent: ((State) -> ())? {
        get {
            return objc_getAssociatedObject(self, &parentKey) as? ((State) -> ())
        }
        set {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &parentKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var children: [(State) -> ()] {
        get {
            return objc_getAssociatedObject(self, &childrenKey) as? [(State) -> ()] ?? []
        }
        set {
            objc_setAssociatedObject(self, &childrenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public init<Parent : Node>(
        state: State,
        parent: Parent,
        updateChild: @escaping (_ parent: Parent.State, _ child: inout State) -> () = { _ in },
        updateParent: @escaping (_ parent: inout Parent.State, _ child: State) -> () = { _ in }
    ) {
        self.init(state: state)
        var ignoreUpdate = false
        parent.children.append { [weak self] parentState in
            guard let child = self, !ignoreUpdate else { return }
            updateChild(parentState, &child.state)
        }
        self.parent = { [weak parent] state in
            guard let parent = parent else { return }
            ignoreUpdate = true
            updateParent(&parent.state, state)
            ignoreUpdate = false
        }
    }
    
    public static func equals(lhs: State, rhs: State) -> Bool {
        return false
    }
    
}

extension Node where Self : NSObject {
    
    public init(state: State) {
        self.init()
        self.state = state
    }
    
}

extension Node where State : Equatable {
    
    static func equals(lhs: State, rhs: State) -> Bool {
        return lhs == rhs
    }
    
}

