# ReactiveKitCoreData

ReactiveKitCoreData is an addition to [Bond](https://github.com/DeclarativeHub/Bond). Its intention is to give a way to bind power of NSFetchedResultsController changes observation with the beauty that Bond's UITableView bidnings are.


# Usage

First and foremost - the framework does not take away the controll over the CoreData stack from you. So the creation of NSFetchRequest and NSFetchedResultsController, as well as actualy performing the fetch request is still up to you. Also, all the usual CoreData threading considerations are still in place. The only exception is - you should not assign the delegate property of NSFetchedResultsController or else the framework will be unable to track changes in it.

Now, let's see how to actualy use what the framework has to offer.

```swift
//The usuall boilerplate of making the fetch request and the controller
let starsRequest =  NSFetchRequest<Star>(entityName: Star.entity().name!)
starsRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Star.name, ascending: true)] //Don't forget this or the runtime will not be happy

let controller = NSFetchedResultsController(fetchRequest: starsRequest,
                                            managedObjectContext:<#viewContext#>,  
                                            sectionNameKeyPath: nil,
                                            cacheName: nil) 

//Now to the interesting part
let observabaleStarsCollection = ObservableCoreDataCollection(fetchController : controller)

//And do the binding
observabaleStarsCollection.bind(to: <#tableView#>,
                                cellType: <#Star cell#>)
{ (cell, star) in
    <#Show the star#>
}

//Don't forget to execute request
do {
    try controller.performFetch()
} catch (error){
    <#Handle error#>
}
```
After this any and all changes that affect your fetched collection will be immidiatly reflexed in the table view.
