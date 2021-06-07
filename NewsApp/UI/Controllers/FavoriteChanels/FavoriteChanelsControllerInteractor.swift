import Shakuro_iOS_Toolbox

protocol FavoriteChanelsControllerInteractorOutput: AnyObject {
    func applyChanges(changes: [FetchedResultsControllerChangeType])
    func failure(error: Error)

}

internal class FavoriteChanelsControllerInteractor {

    public let favoriteChanelsObserver: FetchedResultsController<CDChanel, ManagedChanel>

    private var changes: [FetchedResultsControllerChangeType] = []
    private let taskManager: AppTaskManagerProtocol
    private let dataManager: AppDataManagerProtocol

    private let output: FavoriteChanelsControllerInteractorOutput?

    internal init(taskManager: AppTaskManagerProtocol, dataManager: AppDataManagerProtocol, output: FavoriteChanelsControllerInteractorOutput) {

        self.dataManager = dataManager
        self.taskManager = taskManager
        self.output = output

        favoriteChanelsObserver = dataManager.favoriteChanelsObserver()
        favoriteChanelsObserver.willChangeContent = { _ in }
        favoriteChanelsObserver.didChangeFetchedResults = { [weak self] (_, changes) in
            guard let self = self else {
                return
            }
            self.changes.append(changes)
        }
        favoriteChanelsObserver.didChangeContent = { [weak self] (_) in
            guard let self = self else {
                return
            }
            self.output?.applyChanges(changes: self.changes)
            self.changes.removeAll()
        }
        do {
            try favoriteChanelsObserver.performFetch()
        } catch let error {
            assertionFailure("\(type(of: self)) - \(#function): . \(error)")
        }
    }

}
