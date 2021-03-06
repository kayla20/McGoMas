//
//  WorkoutForms.swift
//  McGoMas
//
//  Created by Mikayla Richardson on 3/22/20.
//  Copyright © 2020 Capstone. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct WorkoutTypeArr {
    let arrWithDefault : Array<String> =
        ["---", "Swim", "Bike", "Run", "Weights"]
}

enum WorkoutType: Int {
    case swim = 1
    case bike = 2
    case run = 3
    case weights = 4
    
    var stringRep : String {
        switch self {
            case WorkoutType.swim:
                return "Swim"
            case WorkoutType.bike:
                return "Bike"
            case WorkoutType.weights:
                return "Weights"
            case WorkoutType.run:
                return "Run"
        }
    }
}


/*
 Models for different types of workouts.
 Stored under user's UID in Firebase Database
 */

class WeightModel: ObservableObject, Identifiable {
    @Published var weight: Weight? 
    var id: UUID
    var pushToDB: Bool = true //denotes a new update/creation
    
    init() {
        self.id = UUID()
    }
    init(withID: UUID) {
        self.id = withID
    }
    
    /*
     Initializes a new weight
     */
    func createWeight() {
        self.weight = Weight(startingSets: [], startingDate: Date())
    }
    
    /*
     Completely remove the workout by setting to nil
     */
    func removeWeight() {
        self.weight = nil
    }
    
    /*
    Add a single set to this weight workout
    */
    func addSet(name: String, mass: Double, massUnit: String, reps: Int) {
        if let myWeight = self.weight {
            myWeight.sets.addSet(set: WeightSet(weightName: name, weight: mass, weightUnit: massUnit, repetitions: reps))
            self.weight = myWeight
        }
    }
    
    /*
    Add a single set to this weight workout
    */
    func addSet(set: WeightSet) {
        if let myWeight = self.weight {
            myWeight.sets.addSet(set: set)
            self.weight = myWeight
        }
    }
    
    /*
    Change the date of the workout
    */
    func changeDate(newDate: Date) {
        if let myWeight = self.weight {
            myWeight.dayCompleted = newDate
            self.weight = myWeight
        }
    }
    
    class Weight {
        var dayCompleted: Date
        var sets: SetArray
        
        /*
         Can optionally specify some predefined sets.
         If none specified, will assume an empty set array
         Can optionally specify a day this was completed.
         Default assumes the date is moment of creation
         */
        init(startingSets: [WeightSet], startingDate: Date?) {
            self.sets = SetArray(fromSets: startingSets)
            
            if let aDate = startingDate {
                self.dayCompleted = aDate
            }
            else {
                self.dayCompleted = Date()
            }
            
        }
    }
}

class SetArray: ObservableObject {
    @Published var sets: [WeightSet]
    
    init(fromSets: [WeightSet]) {
        self.sets = fromSets
    }
    
    init() {
        self.sets = []
    }
    
    func addSet(set: WeightSet) {
        self.sets.append(set)
    }
    
    func removeSet(set: WeightSet) {
        
        let filtered = self.sets.filter( { mySet in
                mySet.id != set.id
            }
        )
        
        self.sets = filtered
    }
}

struct WeightSet: Codable, Identifiable {
    let id: UUID = UUID()
    var weightName: String
    var weight: Double
    var weightUnit: String
    var repetitions: Int
    
    func getStrRep() -> String {
        var builderStr = "Weight name: " + self.weightName + " " + weightUnit
        builderStr += "\n"
        builderStr += "Reps: " + self.repetitions.description
        return builderStr
    }
}


class CardioModel: ObservableObject, Identifiable {
    @Published var cardio: Cardio?
    
    var id: UUID
    var pushToDB: Bool = true //denotes a new update/creation
    
    init() {
        self.id = UUID()
    }
    init(withID: UUID) {
        self.id = withID
    }
    
    /*
     Initializes a new cardio workout
     */
    func createCardio(withType: WorkoutType) {
        self.cardio = Cardio(type: withType, date: nil, distance: nil, distanceUnit: nil, time: nil)
    }
    /*
     Override with options to specify fields
     */
    func createCardio(withType: WorkoutType, date: Date, distance: Double, distanceUnit: String, time: Double) {
        self.cardio = Cardio(type: withType, date: date, distance: distance, distanceUnit: distanceUnit, time: time)
    }
    
    /*
     Completely remove the workout by setting to nil
     */
    func removeCardio() {
        self.cardio = nil
    }
    
    /*
    SETTERS
    */
    func setDate(newDate: Date) {
        if let myCardio = self.cardio {
            myCardio.date = newDate
            self.cardio = myCardio
        }
    }
    
    
    func setDistance(newDistance: Double) {
        if let myCardio = self.cardio {
            myCardio.distance = newDistance
            self.cardio = myCardio
        }
    }
    
    func setUnit(newUnit: String) {
        if let myCardio = self.cardio {
            myCardio.distanceUnit = newUnit
            self.cardio = myCardio
        }
    }

    func setTime(newTime: Double) {
        if let myCardio = self.cardio {
            myCardio.time = newTime
            self.cardio = myCardio
        }
    }
    
    class Cardio {
        //Bike, run, swim...
        var workoutType: WorkoutType
        var date: Date
        //distance covered and its unit (meter/mile/kilometer)
        var distance: Double?
        var distanceUnit: String?
        //time represented in # minutes
        var time: Double?
        
        init(type: WorkoutType, date: Date?, distance: Double?, distanceUnit: String?, time: Double?) {
            self.workoutType = type
            if let date = date {
                self.date = date
            }
            else {
                self.date = Date()
            }
            self.distance = distance
            self.distanceUnit = distanceUnit
            self.time = time
        }
        
    }
}
