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

    public let fetchResultController : NSFetchedResultsController<Object>

    public init(_ resultsController : NSFetchedResultsController<Object>) {
        fetchResultController = resultsController
    }

    public var startIndex: Index {
        return Index(row: 0, section: 0)
    }

    public var endIndex: Index {
        if fetchResultController.fetchedObjects?.count ?? 0 == 0 {
            return startIndex
        } else {
            return Index(row: 0, section: fetchResultController.sections?.count ?? 0)
        }
    }

    public func index(after i: Index) -> Index {
        if let sectionInfo = fetchResultController.sections?[i.section] {
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
        return fetchResultController.object(at: position)
    }
    
    public subscript(position: Int) -> Object {
        return fetchResultController.fetchedObjects![position]
    }
}
