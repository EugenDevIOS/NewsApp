import Alamofire
import Shakuro_iOS_Toolbox
import Shakuro_TaskManager

internal struct FetchNewsChanelsOperationOptions: BaseOperationOptions {
    let apiClient: APIClient
    let dataManager: PoliteCoreStorage
}

internal class FetchNewsChanelsOperation: BaseOperation<Void, FetchNewsChanelsOperationOptions> {

    private var request: Alamofire.Request?

    override func main() {
        let requestOptions = HTTPClient.RequestOptions(endpoint: NewsApiClientEndpoint.allChannels,
                                                       method: .get,
                                                       parser: ChanelsParser())
        request = options.apiClient.sendRequest(options: requestOptions, completion: { (result) in
            guard !self.isCancelled else {
                return self.finish(result: .cancelled)
            }
            switch result {
            case .cancelled:
                self.finish(result: .cancelled)
            case .failure(error: let error):
                self.finish(result: .failure(error: error))
            case .success(result: let result):
                self.save(chanels: result)
            }
        })
    }

    override func internalCancel() {
        request?.cancel()
    }

    override func internalFinished() {
        request = nil
    }

}

// MARK: - Private

private extension FetchNewsChanelsOperation {

    func save(chanels: [Chanel]) {
        let storage = options.dataManager
        storage.save { (context) in
            for item in chanels {
                storage.findFirstOrCreate(
                    CDChanel.self,
                    withPredicate: NSPredicate.objectWithIDPredicate(item.identifier),
                    inContext: context)
                    .update(chanel: item)
            }
        } completion: { (error) in
            guard let error = error else {
                return self.finish(result: .success(result: ()))
            }
            self.finish(result: .failure(error: error))
        }
    }

}
