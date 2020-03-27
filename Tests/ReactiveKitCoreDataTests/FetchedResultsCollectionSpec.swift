//
//  File.swift
//  
//
//  Created by Sergii Martynenko on 3/15/20.
//

import CoreData
import Quick
import Nimble
import CoreDataModelDescription
@testable import ReactiveKitCoreData

@available(iOS 11.0, *)
class FetchedResultsCollectionSpec : QuickSpec {
    let testEnvCD = TestEnviromentCoreData(modelDescription: SimpleModel.model)
    
    func collection<T : NSManagedObject>(sortedBy keys: String..., groupedBy key: String? = nil) -> FetchedResultCollection<T>{
        return FetchedResultCollection(testEnvCD.requestController(sortedBy: keys, groupingBy: key))
    }
    
    override func spec(){
        let noe = 10 // Number of employees
        let emplRange = (1...noe)
        
        describe("fetched results collection") {
            context("\(noe) objects grouped by \(noe) unique keys"){
                let d = emplRange.map{
                    return [
                        "name" : "Person\($0)",
                        "department" : "Dep\($0)"
                    ]
                }
                
                let employees = self.testEnvCD.create(d, of: SimpleModel.Employee.self).sorted { (le, re) -> Bool in
                    return le.department! < re.department!
                }
            
                var fetchedCollection : FetchedResultCollection<SimpleModel.Employee> = collection(sortedBy: "department", groupedBy: "department")
                
                it("contains \(noe) sections"){
                    expect(fetchedCollection.numberOfSections) == noe
                }
                
                it("contains 1 element in each section"){
                    let sectionItemCounts = (0..<emplRange.count).compactMap{ fetchedCollection.numberOfItems(inSection: $0) }
                    expect(sectionItemCounts.filter{$0 == 1}.count) == noe
                }
                
                it("arranged the same as employees"){
                    expect({
                        for (idx, employee) in employees.enumerated() {
                            guard let idxPath = fetchedCollection.index(of: employee) else {
                                return .failed(reason: "No \(employee) in fetched collection (original index \(idx)")
                            }
                            
                            guard idxPath.section == idx, idxPath.row == 0 else{
                                return .failed(reason: "Employee \(employee) is at (section:\(idxPath.section); row:\(idxPath.row)) expected to be at (section:\(idx); row:0)")
                            }
                        }
                        
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
}
