//
//  CoreDataObjectsDynamicCollection.swift
//  BondCoreData
//
//  Created by Sergii Martynenko on 9/24/19.
//  Copyright © 2019 home. All rights reserved.
//

import CoreData
import Foundation

open class NSFetchedResultCollection<Object : NSFetchRequestResult> : Collection {
    public typealias Index = IndexPath
    public typealias Element = Object

    public let fetchResultsController : NSFetchedResultsController<Object>

    public init(_ resultsController : NSFetchedResultsController<Object>) {
        fetchResultsController = resultsController
    }

    public var startIndex: Index {
        return Index(row: 0, section: 0)
    }

    public var endIndex: Index {
        if fetchResultsController.fetchedObjects?.count ?? 0 == 0 {
            return startIndex
        } else {
            return Index(row: 0, section: fetchResultsController.sections?.count ?? 0)
        }
    }

    public func index(after i: Index) -> Index {
        if let sectionInfo = fetchResultsController.sections?[i.section] {
            if i.row + 1 < sectionInfo.numberOfObjects {
                return Index(row: i.row + 1, section: i.section)
            } else {
                return Index(row: 0, section: i.section + 1)
            }
        } else {
            return endIndex
        }
    }

    public subscript(position: Index) -> Object {
        return fetchResultsController.object(at: position)
    }
    
    public subscript(position: Int) -> Object {
        return fetchResultsController.fetchedObjects[position]
    }
}
