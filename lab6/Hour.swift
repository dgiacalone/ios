//
//  Hour.swift
//  lab6
//
//  Created by Delaney Giacalone on 11/2/16.
//  Copyright © 2016 Delaney Giacalone. All rights reserved.
//

import Foundation

class Hour {
    
    var dayOfWeek = ""
    var date = ""
    var hour = -1
    var temp = -1
    var windSpeed = -1
    var pop = -1
    
    init() {
        
    }
    
    init(dayOfWeek: String, date: String, hour: Int, temp: Int, windSpeed: Int, pop: Int) {
        self.dayOfWeek = dayOfWeek
        self.date = date
        self.hour = hour
        self.temp = temp
        self.windSpeed = windSpeed
        self.pop = pop
    }
    
    
}
