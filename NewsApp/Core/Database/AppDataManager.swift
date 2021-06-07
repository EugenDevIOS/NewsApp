import Shakuro_iOS_Toolbox

protocol AppDataManagerProtocol: AnyObject {
    func newsChanelsObserver() -> FetchedResultsController<CDChanel, ManagedChanel>
    func favoriteChanelsObserver() -> FetchedResultsController<CDChanel, ManagedChanel>
}

extension PoliteCoreStorage: AppDataManagerProtocol {

    func newsChanelsObserver() -> FetchedResultsController<CDChanel, ManagedChanel> {
        let fetchResultController = mainQueueFetchedResultsController(CDChanel.self,
                                                                      sortDescriptors: [NSSortDescriptor(key: #keyPath(CDChanel.identifier),
                                                                                                         ascending: true)],
                                                                      configureRequest: nil)
        return FetchedResultsController(fetchedResultsController: fetchResultController)
    }

    func favoriteChanelsObserver() -> FetchedResultsController<CDChanel, ManagedChanel> {
        let fetchResultController = mainQueueFetchedResultsController(CDChanel.self,
                                                                      sortDescriptors: [NSSortDescriptor(key: #keyPath(CDChanel.identifier),
                                                                                                         ascending: true)],
                                                                      predicate: NSPredicate(format: ("%K == true"),
                                                                                             #keyPath(CDChanel.isFavorite)),
                                                                      configureRequest: nil)
        return FetchedResultsController(fetchedResultsController: fetchResultController)
    }

}
