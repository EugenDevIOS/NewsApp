import Shakuro_iOS_Toolbox
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private(set) var appRouter: AppRouter!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let rootNavigationController = UINavigationController()
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()

        let configuration = PoliteCoreStorage.Configuration(modelName: "NewsApp")
        guard let storage = try? PoliteCoreStorage.setupStack(configuration: configuration, removeDBOnSetupFailed: true) else {
            fatalError("Can not setup database")
        }

        let taskManager = AppTaskManager(name: "AppTaskManager",
                                         qualityOfService: .userInitiated,
                                         maxConcurrentOperationCount: 5,
                                         apiClient: APIClient(name: "AppApiClient"),
                                         dataManager: storage)

        appRouter = AppRouter(rootController: rootNavigationController,
                              taskManager: taskManager,
                              dataManager: storage)
        appRouter?.presentController(type: ChanelsViewController.self,
                                     options: (),
                                     fromViewController: nil,
                                     style: .pushDefault,
                                     animated: true)
        return true
    }

}
