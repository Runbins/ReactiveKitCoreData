
//
//  File.swift
//  
//
//  Created by Sergii Martynenko on 3/15/20.
//

import CoreData
import CoreDataModelDescription

@available(iOS 11.0, *)
struct SimpleModel {
    class Person : NSManagedObject {
        @NSManaged var name : String?
        @NSManaged var phone : String?
    }

    class Employee : Person {
        @NSManaged var department : String?
    }
    
    static var model = CoreDataModelDescription(
        entities: [
        .entity(name: "Person",
                managedObjectClass: SimpleModel.Person.self,
                attributes: [
                    .attribute(name: "name", type: .stringAttributeType),
                    .attribute(name: "phone", type: .stringAttributeType)
        ]),
        
        .entity(name: "Employee",
                managedObjectClass: SimpleModel.Employee.self,
                parentEntity: "Person",
                attributes: [
                    .attribute(name: "department", type: .stringAttributeType)
        ])
        ]).makeModel()
}

@available(iOS 11.0, *)
struct ModelWithRelation {
    class Department : NSManagedObject {
        @NSManaged var name : String?
        @NSManaged var employees : NSSet
    }
    
    class Employee: NSManagedObject {
        @NSManaged var name: String?
        @NSManaged var department: Department?
    }
    
    static var modelDescription = CoreDataModelDescription(entities:
        [
            .entity(name: "Employee",
                    managedObjectClass: Employee.self,
                    attributes: [
                        .attribute(name: "name",
                                   type: .stringAttributeType),
//                        .attribute(name: "department",
//                                   type: .objectIDAttributeType)
                ],
                    relationships: [
                        .relationship(name: "department",
                                      destination: "Department",
                                      optional: true,
                                      toMany: false,
                                      deleteRule: .nullifyDeleteRule,
                                      inverse: "employees")
            ]),
            
            .entity(name: "Department",
                    managedObjectClass: Department.self,
                    attributes: [
                        .attribute(name: "name", type: .stringAttributeType),
            ],
                    relationships: [
                        .relationship(name: "employees",
                                      destination: "Employee",
                                      optional: true,
                                      toMany: true,
                                      deleteRule: .cascadeDeleteRule,
                                      inverse: "department")
            ])
        ]).makeModel()
}

@available(iOS 11.0, *)
extension ModelWithRelation.Department {
    func addToEmployees(_ value: ModelWithRelation.Employee){
        self.willChangeValue(for: \ModelWithRelation.Department.employees)
        self.employees = self.employees.adding(value) as NSSet
        self.didChangeValue(for: \ModelWithRelation.Department.employees)
    }
    
    func addToEmployees(_ values: [ModelWithRelation.Employee]){
        self.willChangeValue(for: \ModelWithRelation.Department.employees)
        self.employees = employees.addingObjects(from: values) as NSSet
        self.didChangeValue(for: \ModelWithRelation.Department.employees)
    }
}
