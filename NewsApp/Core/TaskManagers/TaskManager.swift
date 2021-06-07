import Shakuro_iOS_Toolbox
import Shakuro_TaskManager

protocol AppTaskManagerProtocol: AnyObject {
    func fetchNewsChanel() -> Task<Void>
    func addChanelToFavoriteList(chanelIdentifier: String) -> Task<Void>
}

internal class AppTaskManager: TaskManager {

    private let apiClient: APIClient
    private let dataManager: PoliteCoreStorage

    init(name aName: String,
         qualityOfService: QualityOfService,
         maxConcurrentOperationCount: Int,
         apiClient: APIClient,
         dataManager: PoliteCoreStorage) {
        self.apiClient = apiClient
        self.dataManager = dataManager
        super.init(name: aName,
                   qualityOfService: qualityOfService,
                   maxConcurrentOperationCount: maxConcurrentOperationCount)
    }

}

extension AppTaskManager: AppTaskManagerProtocol {

    func fetchNewsChanel() -> Task<Void> {
        performOperation(operationType: FetchNewsChanelsOperation.self,
                         options: FetchNewsChanelsOperationOptions(apiClient: apiClient,
                                                                   dataManager: dataManager))
    }

    func addChanelToFavoriteList(chanelIdentifier: String) -> Task<Void> {
        performOperation(operationType: AddFavoriteChanelOperation.self,
                         options: AddFavoriteChanelOperationOptions(chanelID: chanelIdentifier,
                                                                    dataManager: dataManager))
    }

}
