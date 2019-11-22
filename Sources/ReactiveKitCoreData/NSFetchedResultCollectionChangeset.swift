//
//  CoreDataObjectsDynamicCollectionChangeset.swift
//  BondCoreData
//
//  Created by Sergii Martynenko on 9/24/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import CoreData
import ReactiveKit
import Bond


open class NSFetchedResultCollectionChangeset<Element : NSFetchRequestResult> : SectionedDataSourceChangeset, SectionedDataSourceChangesetConvertible {
    public typealias Changeset = NSFetchedResultCollectionChangeset<Element>
    
    public typealias Operation = OrderedCollectionOperation<Element, IndexPath>
    public typealias Diff = OrderedCollectionDiff<IndexPath>
    public typealias Collection = NSFetchedResultCollection<Element>

    public var diff: OrderedCollectionDiff<IndexPath>

    public var patch: [OrderedCollectionOperation<Element, IndexPath>]

    public var collection: NSFetchedResultCollection<Element>

    public var asSectionedDataSourceChangeset: NSFetchedResultCollectionChangeset<Element> {
        return self
    }
    
    public required init(collection: NSFetchedResultCollection<Element>,
                  patch: [OrderedCollectionOperation<Element, IndexPath>]) {
        self.collection = collection
        diff = Diff()
        self.patch = patch
    }

    public required init(collection: NSFetchedResultCollection<Element>,
                  diff: OrderedCollectionDiff<IndexPath>) {
        self.collection = collection
        self.diff = diff
        self.patch = []
    }
}

extension NSFetchedResultCollection : SectionedDataSourceProtocol {
    public var numberOfSections: Int {
        return fetchResultsController.sections?.count ?? 0
    }

    public func numberOfItems(inSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
}

extension NSFetchedResultCollection : QueryableSectionedDataSourceProtocol {
    public typealias Item = Object

    public func item(at indexPath: IndexPath) -> Object {
        return self[indexPath]
    }
}
