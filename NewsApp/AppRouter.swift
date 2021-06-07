import Shakuro_iOS_Toolbox

protocol RoutingDataProtocol {
    var taskManager: AppTaskManagerProtocol { get }
    var dataManager: AppDataManagerProtocol { get }
}

protocol RouterHelperProtocol {
    @discardableResult
    func presentController<T: ViewController>(type: T.Type,
                                              options: T.OptionsType,
                                              fromViewController: UIViewController?,
                                              style: NavigationStyle,
                                              animated: Bool) -> UIViewController?
}
typealias ViewController = UIViewController & BaseViewControllerProtocol
typealias AppRouterProtocol = RoutingDataProtocol & RouterHelperProtocol & RouterProtocol & RoutingURLProtocol & RoutingAlertsProtocol

internal class AppRouter: Router {

    private var internalTaskManager: AppTaskManager
    private var internalDataManager: PoliteCoreStorage

    init(rootController: UINavigationController, taskManager: AppTaskManager, dataManager: PoliteCoreStorage) {
        self.internalTaskManager = taskManager
        self.internalDataManager = dataManager
        super.init(rootController: rootController)
    }

}

// MARK: - RoutingDataProtocol

extension AppRouter: RoutingDataProtocol {

    var taskManager: AppTaskManagerProtocol {
        return internalTaskManager
    }

    var dataManager: AppDataManagerProtocol {
        return internalDataManager
    }

}

extension AppRouter: RouterHelperProtocol {

    @discardableResult
    func presentController<T>(type: T.Type,
                              options: T.OptionsType,
                              fromViewController: UIViewController?,
                              style: NavigationStyle,
                              animated: Bool) -> UIViewController? where T: UIViewController, T: BaseViewControllerProtocol {
        let viewController = type.instantiate(self, options: options)
        return presentViewController(controller: viewController, from: fromViewController, style: style, animated: animated)
    }

}
