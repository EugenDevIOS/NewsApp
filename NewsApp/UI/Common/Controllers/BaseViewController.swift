import UIKit

protocol BaseViewControllerProtocol: AnyObject {

    associatedtype OptionsType

    static func instantiate(_ appRouter: AppRouter, options: OptionsType) -> UIViewController
}

class BaseViewController: UIViewController {

    weak var appRouter: AppRouter?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: - Public

extension BaseViewControllerProtocol {

    public static func unwrap<T>(_ block: () -> T?) -> T {
        guard let result = block() else {
            fatalError("Can not instantiate view controller from storyboard")
        }
        return result

    }
}
