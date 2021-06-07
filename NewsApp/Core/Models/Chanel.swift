import CoreData
import Shakuro_iOS_Toolbox

internal class Chanel {

    let identifier: String
    let name: String
    var isFavorite: Bool
    var description: String?
    var url: String?
    var category: String?
    var language: String?
    var country: String?

    internal init(identifier: String,
                  name: String,
                  isFavorite: Bool,
                  description: String?,
                  url: String?,
                  category: String?,
                  language: String?,
                  country: String?) {
        self.identifier = identifier
        self.name = name
        self.isFavorite = isFavorite
        self.description = description
        self.url = url
        self.category = category
        self.language = language
        self.country = country
    }

    init(entity: CDChanel) {
        self.identifier = entity.identifier
        self.name = entity.name
        self.isFavorite = entity.isFavorite
    }

}

final class ManagedChanel: Chanel, ManagedEntity {

    var objectID: NSManagedObjectID

    override init(entity: CDChanel) {
        self.objectID = entity.objectID
        super.init(entity: entity)
    }

}
