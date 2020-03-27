//
//  File.swift
//  
//
//  Created by Sergii Martynenko on 3/24/20.
//

import CoreData

import Quick
import Nimble

import CoreDataModelDescription
import ReactiveKit
import Bond

import UIKit

@testable import ReactiveKitCoreData


@available(iOS 11.0, *)
class ObservableCoreDataCollectionSpec : QuickSpec {
    typealias Employee = ModelWithRelation.Employee
    typealias Department = ModelWithRelation.Department
    
    
    override func spec(){
        let testEnvCD = TestEnviromentCoreData(modelDescription: ModelWithRelation.modelDescription)
        
        let observedCollection =
            ObservableCoreDataCollection<Employee>(fetchController:
                testEnvCD.requestController(sortedBy: ["department.name", "name"],
                                            groupingBy: "department.name"))
        
        var collection: FetchedResultCollection<Employee> {
            return observedCollection.value.collection
        }
        
        let tb = UITableView(frame: .zero)
        observedCollection.bind(to: tb, cellType: UITableViewCell.self){ cell, empl in
            
        }
        
        describe("observable core data collection"){
            afterEach {
                testEnvCD.moc.registeredObjects.forEach{ testEnvCD.moc.delete($0)}
                try! testEnvCD.moc.save()
            }
            
            context("changes done on main thread"){
                var departments : [Department] = []
                
                describe("create 2 employees with Department 1"){
                    beforeEach {
                        departments =
                            testEnvCD.create((1...2)
                                .map{return ["name" : "Department \($0)"]})
                                .sorted { $0.name! < $1.name! }
                        
                        let dep1 = departments[0]
                        testEnvCD.create([["name" : "Peter", "department" : dep1]], of: Employee.self)
                        testEnvCD.create([["name" : "Carl",  "department" : dep1]], of: Employee.self)
                        try! testEnvCD.moc.save()
                    }
                    
                    it("have 2 employees"){
                        expect(collection.count) == 2
                    }
                    
                    it("have 1 section"){
                        expect(collection.numberOfSections) == 1
                    }
                    
                    it("have 2 employees in section 0"){
                        expect(collection.numberOfItems(inSection: 0)) == 2
                    }
                }
                
                describe("create 3 departments with 2 employees in each"){
                    beforeEach {
                        departments =
                            testEnvCD.create((1...3)
                                .map{return ["name" : "Department \($0)"]})
                                .sorted { $0.name! < $1.name! }
                        
                        let names = ["Frank", "George", "Simon", "Jhon", "James", "Liam"]
                        var namesIter = names.makeIterator()
                        
                        for d in departments {
                            for _ in (1...2) {
                                d.addToEmployees(testEnvCD.create([["name" : namesIter.next()!]],
                                                                  of: Employee.self))
                            }
                        }
                        
                        try! testEnvCD.moc.save()
                    }
                    
                    it("have 3 sections"){
                        expect(collection.numberOfSections) == 3
                    }
                    
                    it("have 2 employees in each section"){
                        for i in (0..<collection.numberOfSections){
                            expect(collection.numberOfItems(inSection: i)) == 2
                        }
                    }
                    
                    describe("delete first department"){
                        beforeEach {
                            testEnvCD.moc.delete(departments.first!)
                            try! testEnvCD.moc.save()
                        }
                        
                        it("should have 4 items"){
                            expect(collection.count) == 4
                        }
                        
                        it("shoud have 2 sections and 2 employees each"){
                            expect(collection.numberOfSections) == 2
                            for i in (0..<collection.numberOfSections){
                                expect(collection.numberOfItems(inSection: i)) == 2
                            }
                        }
                    }
                }
            }
        }
    }
}
