//
//  TenDay.swift
//  lab6
//
//  Created by Delaney Giacalone on 11/1/16.
//  Copyright © 2016 Delaney Giacalone. All rights reserved.
//

import Foundation

class TenDay {
    
    var dayOfWeek = ""
    var forecast = ""
    var dailyHigh = -1
    var dailyLow = -1
    var pop = -1
    
    init() {

    }
    
    init(dayOfWeek: String, forecast: String, dailyHigh: Int, dailyLow: Int, pop: Int) {
        self.dayOfWeek = dayOfWeek
        self.forecast = forecast
        self.dailyHigh = dailyHigh
        self.dailyLow = dailyLow
        self.pop = pop
    }
    
}
