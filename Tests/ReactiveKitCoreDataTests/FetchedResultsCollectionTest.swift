//
//  File.swift
//  
//
//  Created by Sergii Martynenko on 3/14/20.
//

import CoreData
import CoreDataModelDescription

import XCTest
@testable import ReactiveKitCoreData

@available(iOS 11.0, *)
final class FetchedResultsCollectionTest : XCTestCase {
    let testEnviromentCD = TestEnviromentCoreData(modelDescription: SimpleModel.model)
    
    func collection<T : NSManagedObject>(sortedBy keys: String...) -> FetchedResultCollection<T>{
        return FetchedResultCollection(testEnviromentCD.requestController(sortedBy: keys))
    }
    
    func fillWithPersons(_ count : Int = 10){
        let d = (1...10).map {
            return ["name" : "Person\($0)"]
        }
        
        testEnviromentCD.create(d, of: SimpleModel.Person.self)
    }
    
    //SUT
    var fetchedCollection : FetchedResultCollection<SimpleModel.Person>!

   
    func testStartIndexIsSection0Row0InEmptyCollection(){
        fetchedCollection = FetchedResultCollection(testEnviromentCD.requestController(sortedBy: "name"))
        
        XCTAssert(fetchedCollection.startIndex == IndexPath(row: 0, section: 0))
    }
    
    func testStartIndexIsSection0Row0InNonEmptyCollection(){
        fillWithPersons()
        
        fetchedCollection = collection(sortedBy: "name")
        
        XCTAssert(fetchedCollection.startIndex == IndexPath(row: 0, section: 0))
    }
    
    func testCountIs10(){
        fillWithPersons()
        
        fetchedCollection = collection(sortedBy: "name")
        
        XCTAssert(fetchedCollection.count == 10)
    }
    
    func testEndIndexIsSection1(){
        fillWithPersons()
        
        fetchedCollection = collection(sortedBy: "name")
        
        XCTAssert(fetchedCollection.endIndex == IndexPath(row: 0, section: 1))
    }
    
    
    static var allTests = [
        ("test_startIndex_section0_row0_in_empty_collection", testStartIndexIsSection0Row0InEmptyCollection),
        ("testStartIndexIsSection0Row0InNonEmptyCollection", testStartIndexIsSection0Row0InNonEmptyCollection),
        ("testCountIs10", testCountIs10),
        ("testEndIndexIsSection1", testEndIndexIsSection1)
        
    ]
}
