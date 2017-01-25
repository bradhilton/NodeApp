import UIKit

class DetailViewController: UIViewController, Node {
    
    let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        textField.becomeFirstResponder()
        textField.text = state
    }
    
    func editingChanged(textField: UITextField) {
        state = textField.text ?? ""
    }
    
    func didSet(state: String, oldValue: String) {
        textField.text = state
    }

}
