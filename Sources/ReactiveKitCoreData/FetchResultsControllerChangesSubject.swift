//
//  FetchResultsControllerObserver.swift
//  BondCoreData
//
//  Created by Sergii Martynenko on 9/24/19.
//  Copyright © 2019 home. All rights reserved.
//

import Foundation
import CoreData
import Bond
import ReactiveKit

open class FetchResultsControllerChangesSubject<Element : NSFetchRequestResult>: Subject<NSFetchedResultCollectionChangeset<Element>, Never> {
    
    public let fetchedCollection : NSFetchedResultCollection<Element>
    
    private let controllerDelegate = _FetchControllerDelegate<Element>()
    
    public init(_ controller: NSFetchedResultsController<Element>){
        fetchedCollection = NSFetchedResultCollection(controller)
        
        super.init()
        
        controllerDelegate.changesObserver = self
        fetchedCollection.fetchResultController.delegate = controllerDelegate
    }
}



fileprivate class _FetchControllerDelegate<Element : NSFetchRequestResult> : NSObject, NSFetchedResultsControllerDelegate{
    fileprivate var currentEventChanges : [SectionedCollectionChangeOperation<Element>] = []
    unowned var changesObserver : FetchResultsControllerChangesSubject<Element>!
    //MARK: - NSFetchedResultsControllerDelegate
    
    @objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        currentEventChanges = []
    }
    
    @objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        changesObserver.send(NSFetchedResultCollectionChangeset.init(collection: changesObserver.fetchedCollection,
                                                                     patch: currentEventChanges))
        
        currentEventChanges = []
    }
    
    @objc(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        let object = anObject as! Element
        
        switch type {
        case .delete:
            currentEventChanges.append(.delete(object, at: indexPath!))
        case .insert:
            currentEventChanges.append(.insert(object, at: newIndexPath!))
        case .update:
            currentEventChanges.append(.update(at: indexPath!, newElement: object))
        case .move:
            currentEventChanges.append(.move(object, from: indexPath!, to: newIndexPath!))
        @unknown default:
            break
        }
    }
    
    @objc(controller:didChangeSection:atIndex:forChangeType:) func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        let objects = sectionInfo.objects as? [Element]
        
        switch type {
        case .delete:
            currentEventChanges.append(.deleteSection(objects ?? [], at: IndexPath(index: sectionIndex)))
        case .insert:
            currentEventChanges.append(.insertSection(objects ?? [], at: IndexPath(index: sectionIndex)))
        default:
            break
        }
    }

}
