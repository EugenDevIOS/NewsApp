import Shakuro_iOS_Toolbox
import Shakuro_TaskManager

internal struct AddFavoriteChanelOperationOptions: BaseOperationOptions {
    let chanelID: String
    let dataManager: PoliteCoreStorage
}

internal class AddFavoriteChanelOperation: BaseOperation<Void, AddFavoriteChanelOperationOptions> {

    override func main() {

        let storage = options.dataManager
        let chanelID = options.chanelID
        storage.save { (context) in
            let chanel = storage.findFirstById(CDChanel.self,
                                               identifier: chanelID,
                                               inContext: context)
            guard let isFavorite = chanel?.isFavorite else {
                return
            }
            chanel?.isFavorite = !isFavorite
        } completion: { (error) in
            guard let error = error else {
                return self.finish(result: .success(result: ()))
            }
            self.finish(result: .failure(error: error))
        }
    }

}
