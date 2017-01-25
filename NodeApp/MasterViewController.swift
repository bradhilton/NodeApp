import UIKit

let defaultState = "Hello, world"

class MasterViewController: UIViewController, Node {
    
    let label = UILabel()
    
    lazy var detailViewController: DetailViewController = .init(
        state: self.state,
        parent: self,
        updateChild: { $1 = $0 },
        updateParent: { $0 = $1 }
    )
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        state = defaultState
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Master"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(resetButtonTapped)
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        label.text = state
    }
    
    func resetButtonTapped() {
        state = defaultState
    }
    
    func didSet(state: String, oldValue: String) {
        label.text = state
    }

}
