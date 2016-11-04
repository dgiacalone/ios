//
//  ViewController.swift
//  lab6
//
//  Created by Delaney Giacalone on 10/26/16.
//  Copyright © 2016 Delaney Giacalone. All rights reserved.
//

import UIKit

class HourDetailsViewController: UIViewController {

    var hourSelected : Hour?
    let backgroundColor = UIColor(red: 171/255, green: 219/255, blue: 234/255, alpha: 1)
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var popLabel: UILabel!
    @IBOutlet weak var uviLabel: UILabel!
    @IBOutlet weak var heatIndexLabel: UILabel!
    @IBOutlet weak var windChillLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setLabels()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLabels() {
        hourLabel.text = String(describing: hourSelected!.hour)
        dayLabel.text = hourSelected!.dayOfWeek
        dateLabel.text = hourSelected!.date
        tempLabel.text = "\(hourSelected!.temp)°"
        windSpeedLabel.text = "Wind Speed: \(hourSelected!.windSpeed) mph"
        popLabel.text = "Chance of Rain: \(hourSelected!.pop)%"
        uviLabel.text = "UVI: \(hourSelected!.uvi)"
        heatIndexLabel.text = "Heat Index: \(hourSelected!.heatIndex)"
        windChillLabel.text = "Wind Chill: \(hourSelected!.windChill)"
    }


}

