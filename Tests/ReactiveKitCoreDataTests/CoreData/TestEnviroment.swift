//
//  File.swift
//  
//
//  Created by Sergii Martynenko on 3/24/20.
//

import Foundation
import CoreData

@available(iOS 11.0, *)
class TestEnviromentCoreData {
    private let model : NSManagedObjectModel
    
    init(modelDescription: NSManagedObjectModel){
        model = modelDescription
        
        let container = NSPersistentContainer(name: "TestContainer",
                                              managedObjectModel: model)
        
        let storeDescritpion = NSPersistentStoreDescription()
        storeDescritpion.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [storeDescritpion]
        
        container.loadPersistentStores { (description, error) in
            if let failure = error {
                print(failure)
                fatalError()
            }
        }
        
        persistentCoordinator = container
    }
    
    var persistentCoordinator : NSPersistentContainer
    
    var moc : NSManagedObjectContext {
        return persistentCoordinator.viewContext
    }
    
    func fetchResultController<T : NSFetchRequestResult>(for request: NSFetchRequest<T>,
                                                         groupedBy key: String? = nil) -> NSFetchedResultsController<T>{
        
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: moc,
                                                    sectionNameKeyPath: key,
                                                    cacheName: nil)
        try! controller.performFetch()
        controller.sections
        return controller
    }
    
    func requestController<T : NSManagedObject>(sortedBy keys: String...) -> NSFetchedResultsController<T>{
        requestController(sortedBy: keys)
    }
    
    func requestController<T : NSManagedObject>(sortedBy keys: [String],
                                                groupingBy key: String? = nil) -> NSFetchedResultsController<T>{
        
        let request = T.fetchRequest() as! NSFetchRequest<T>
        request.sortDescriptors = keys.map{
            NSSortDescriptor(key: $0, ascending: true)
        }
        
        return fetchResultController(for: request, groupedBy: key)
    }
    
    @discardableResult
    func create<Obj : NSManagedObject>(_ description: [[String : Any]], of type: Obj.Type = Obj.self) -> [Obj] {
        return description
            .map{ d in
                let obj = Obj(entity: Obj.entity(), insertInto: moc)
                for k in d.keys{
                    obj.setValue(d[k], forKey: k)
                }
                return obj
            }
    }
}
