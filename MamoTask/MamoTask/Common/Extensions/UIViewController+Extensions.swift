

import UIKit

extension UIViewController {
    func showErrorAlert(error: Error) {
        self.showAlert(string: error.localizedDescription)
    }
    
    func showAlert(string: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "OPS",
                                      message: string,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
