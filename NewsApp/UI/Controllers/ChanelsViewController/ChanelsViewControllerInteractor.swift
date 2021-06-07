import CoreData
import Shakuro_iOS_Toolbox

protocol ChanelsViewControllerProtocol {
    func applyChanges(changes: [FetchedResultsControllerChangeType])
    func failure(error: Error)
}

internal class ChanelsViewControllerInteractor {

    public var chanelsObserver: FetchedResultsController<CDChanel, ManagedChanel>

    private var changes: [FetchedResultsControllerChangeType] = []
    private let taskManager: AppTaskManagerProtocol
    private let dataManager: AppDataManagerProtocol

    private var output: ChanelsViewControllerProtocol?

    internal init(taskManager: AppTaskManagerProtocol, dataManager: AppDataManagerProtocol, output: ChanelsViewControllerProtocol) {

        self.taskManager = taskManager
        self.dataManager = dataManager
        self.output = output

        chanelsObserver = dataManager.newsChanelsObserver()
        chanelsObserver.willChangeContent = { _ in }
        chanelsObserver.didChangeFetchedResults = { [weak self] (_, changeType) in
            guard let self = self else {
                return
            }
            self.changes.append(changeType)
        }
        chanelsObserver.didChangeContent = { [weak self] (_) in
            guard let self = self else {
                return
            }
            self.output?.applyChanges(changes: self.changes)
            self.changes.removeAll()
        }
        do {
            try chanelsObserver.performFetch()
        } catch let error {
            assertionFailure("\(type(of: self)) - \(#function): . \(error)")
        }
    }

}

// MARK: - Public

extension ChanelsViewControllerInteractor {

    func fetchChanels() {
        let task = taskManager.fetchNewsChanel()
        task.onComplete(queue: .global(), closure: { [weak self] (_, result) in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(error: let error):
                self.output?.failure(error: error)
            default:
                break
            }
        })
    }

    func addChanelToFavoriteList(identifier: String) {
        let task = taskManager.addChanelToFavoriteList(chanelIdentifier: identifier)
        task.onComplete(queue: .global()) { [weak self] (_, result) in
            guard let self = self else {
                return
            }
            switch result {
            case .failure(error: let error):
                self.output?.failure(error: error)
            default:
                break
            }
        }
    }

}
