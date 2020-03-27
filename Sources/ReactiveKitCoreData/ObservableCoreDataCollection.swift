//
//  File.swift
//  
//
//  Created by Sergii Martynenko on 3/26/20.
//

import Foundation
import CoreData

import ReactiveKit

typealias ObservableCoreDataCollection<O: NSFetchRequestResult> = AnyProperty<FetchedResultCollectionChangeset<O>>

extension AnyProperty {
    convenience init<Obj : NSFetchRequestResult>(fetchController: NSFetchedResultsController<Obj>) where Value == FetchedResultCollectionChangeset<Obj> {
        let s = FetchResultsControllerChangesSubject(fetchController)
        let initialV = FetchedResultCollectionChangeset(collection: s.fetchedCollection)
        
        self.init(property: Property(initialV, subject: s))
    }
}
