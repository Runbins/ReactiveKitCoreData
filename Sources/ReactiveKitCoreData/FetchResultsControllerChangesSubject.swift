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

typealias DynamicCollectionUpdates<Object : NSFetchRequestResult> = Signal<NSFetchedResultCollectionChangeset<Object>, Never>


open class FetchResultsControllerChangesSubject: Subject<OrderedCollectionDiff<IndexPath>, Never> {
    
    fileprivate class _FetchControllerDelegate : NSObject, NSFetchedResultsControllerDelegate{
        fileprivate var currentEventChanges : OrderedCollectionDiff<IndexPath>? = nil
        unowned var changesObserver : FetchResultsControllerChangesSubject!
    }
    
    public let fetchController : NSFetchedResultsController<NSFetchRequestResult>
    
    
    private let controllerDelegate = _FetchControllerDelegate()
    
    
    public init(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        fetchController = controller
        
        super.init()
        
        controllerDelegate.changesObserver = self
        fetchController.delegate = controllerDelegate
    }
}



extension FetchResultsControllerChangesSubject._FetchControllerDelegate  {
    //MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        currentEventChanges = OrderedCollectionDiff()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        changesObserver.send(currentEventChanges!)
        currentEventChanges = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            currentEventChanges?.deletes.append(indexPath!)
        case .insert:
            currentEventChanges?.inserts.append(newIndexPath!)
        case .update:
            currentEventChanges?.updates.append(indexPath!)
        case .move:
            currentEventChanges?.moves.append((from: indexPath!, to: newIndexPath!))
        @unknown default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        switch type {
        case .delete:
            currentEventChanges?.deletes.append(IndexPath(index: sectionIndex))
        case .insert:
            currentEventChanges?.inserts.append(IndexPath(index: sectionIndex))
        default:
            break
        }
    }

}
