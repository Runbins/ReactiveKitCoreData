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


public enum SectionedCollectionChangeOperation<Element>  {
    public typealias Index = IndexPath
    
    case insert(Element, at: Index)
    case delete(Element, at: Index)
    case update(at: Index, newElement: Element)
    case move(Element, from: Index, to: Index)
    
    case deleteSection([Element], at: Index)
    case insertSection([Element], at: Index)
}

open class NSFetchedResultCollectionChangeset<Element : NSFetchRequestResult> : SectionedDataSourceChangeset, SectionedDataSourceChangesetConvertible {
    public typealias Changeset = NSFetchedResultCollectionChangeset<Element>
    
    public typealias Operation = SectionedCollectionChangeOperation<Element>
    public typealias Diff = OrderedCollectionDiff<IndexPath>
    public typealias Collection = NSFetchedResultCollection<Element>

    public var diff: Diff
    public var patch: [Operation]
    public var collection: Collection
    
    public var asSectionedDataSourceChangeset: NSFetchedResultCollectionChangeset<Element> {
        return self
    }
    
    public required init(collection: Collection,
                         patch: [Operation]) {
        self.collection = collection
        diff = patch.reduce(into: Diff()) { (diff, operation) in
            switch operation {
            case .delete(_, at: let idx), .deleteSection(_, let idx):
                diff.deletes.append(idx)
                
            case .insert(_, at: let idx), .insertSection(_, let idx):
                diff.inserts.append(idx)
                
            case .move(_, from: let orig, to: let dest):
                diff.moves.append((from: orig, to: dest))
                
            case .update(at: let idx, newElement: _):
                diff.updates.append(idx)
            }
        }
        self.patch = patch
    }

    public required init(collection: Collection,
                         diff: Diff) {
        self.collection = collection
        self.diff = diff
        self.patch = []
    }
}

extension NSFetchedResultCollection : SectionedDataSourceProtocol {
    public var numberOfSections: Int {
        return fetchResultController.sections?.count ?? 0
    }

    public func numberOfItems(inSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
}

extension NSFetchedResultCollection : QueryableSectionedDataSourceProtocol {
    public typealias Item = Object

    public func item(at indexPath: IndexPath) -> Object {
        return self[indexPath]
    }
}
