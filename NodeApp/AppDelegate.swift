import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let splitViewController = UISplitViewController()
        splitViewController.view.backgroundColor = .white
        let masterViewController = MasterViewController()
        splitViewController.viewControllers = [
            UINavigationController(rootViewController: masterViewController),
            UINavigationController(rootViewController: masterViewController.detailViewController)
        ]
        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()
        return true
    }

}

