import CoreData

extension CDChanel {

    @discardableResult
    func update(chanel: Chanel) -> Bool {

        var changed: Bool = false
        guard isInserted || chanel.identifier == identifier else {
            return changed
        }

        changed = apply(path: \.identifier, value: chanel.identifier) || changed
        changed = apply(path: \.name, value: chanel.name) || changed

        return changed

    }

    func apply<Value>(path: ReferenceWritableKeyPath<CDChanel, Value?>, value: Value?) -> Bool where Value: Equatable {
        return NSManagedObject.applyValue(to: self, path: path, value: value)
    }

    func apply<Value>(path: ReferenceWritableKeyPath<CDChanel, Value>, value: Value) -> Bool where Value: Equatable {
        return NSManagedObject.applyValue(to: self, path: path, value: value)
    }

}
