import CoreData
import Foundation

extension CDChanel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDChanel> {
        return NSFetchRequest<CDChanel>(entityName: "CDChanel")
    }

    @NSManaged public var identifier: String
    @NSManaged public var name: String
    @NSManaged public var isFavorite: Bool

}
