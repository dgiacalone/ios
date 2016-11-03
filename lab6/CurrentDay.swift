//
//  CurrentDay.swift
//  lab6
//
//  Created by Delaney Giacalone on 10/26/16.
//  Copyright © 2016 Delaney Giacalone. All rights reserved.
//

import Foundation

class CurrentDay{
    
    var city = ""
    var currentConditions = ""
    var temp = -1
    var dayofWeek = ""
    var dailyHigh = -1
    var dailyLow = -1
    var windSpeed = -1
    var windDirection = ""
    
    init() {
        
    }
    
    init(city: String, currentConditions: String, temp: Int, dayOfWeek: String, dailyHigh: Int, dailyLow: Int, windSpeed: Int, windDirection: String) {
        self.city = city
        self.currentConditions = currentConditions
        self.temp = temp
        self.dayofWeek = dayOfWeek
        self.dailyHigh = dailyHigh
        self.dailyLow = dailyLow
        self.windSpeed = windSpeed
        self.windDirection = windDirection
    }
}
