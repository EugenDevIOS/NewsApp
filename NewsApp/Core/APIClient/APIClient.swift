import Shakuro_iOS_Toolbox

internal enum APIClientError: Swift.Error {
    case invalidData
    case listChanelIsEmpty
}

internal enum NewsApiClientEndpoint {
    case allChannels
}

internal class APIClient: HTTPClient {
}

extension NewsApiClientEndpoint: HTTPClientAPIEndPoint {

    func urlString() -> String {
        switch self {
        case .allChannels:
            return "https://newsapi.org/v2/sources?apiKey=aeb80c27ca814807bfdd98f04fd3b07c"
        }
    }

}
