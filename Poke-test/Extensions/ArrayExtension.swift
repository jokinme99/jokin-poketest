//
//  ArrayExtension.swift
//  Poke-test
//
//  Created by Jokin Egia on 25/4/22.
//

import Foundation
import RealmSwift

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension Array where Element: EmbeddedObject {
    func transformArrayToList() -> List<Element> {
        let list = List<Element>()
        for element in self {
            list.append(element)
        }
        return list
    }
}

extension Array where Element: Object {
    func transformArrayToList() -> List<Element> {
        let list = List<Element>()
        for element in self {
            list.append(element)
        }
        return list
    }
}
