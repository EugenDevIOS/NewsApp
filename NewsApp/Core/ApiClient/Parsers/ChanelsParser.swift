import Shakuro_iOS_Toolbox
import SwiftyJSON

internal class ChanelsParser: HTTPClientParser {

    typealias ResultType = [Chanel]
    typealias ResponseValueType = JSON

    func serializeResponseData(_ responseData: Data?) throws -> JSON {
        var data = JSON()
        guard let response = responseData else {
            return data
        }
        data = JSON(response)
        return data
    }

    func parseForError(response: HTTPURLResponse?, responseData: Data?) -> Error? {
        guard let response = responseData, !response.isEmpty else {
            return ApiClientError.listChanelIsEmpty
        }
        return nil
    }

    func parseForResult(_ serializedResponse: JSON, response: HTTPURLResponse?) throws -> [Chanel] {

        guard let response = serializedResponse["sources"].array else {
            throw ApiClientError.invalidData
        }
        var chanels: [Chanel] = []
        response.forEach({
            guard let identifier = $0["id"].string, let name = $0["name"].string else {
                return
            }
            let chanel = Chanel(identifier: identifier,
                                name: name,
                                isFavorite: false,
                                description: $0["description"].string,
                                url: $0["url"].string,
                                category: $0["category"].string,
                                language: $0["language"].string,
                                country: $0["country"].string)
            chanels.append(chanel)
        })
        return chanels
    }

}
