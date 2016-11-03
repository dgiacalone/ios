//
//  TableViewController.swift
//  lab6
//
//  Created by Delaney Giacalone on 10/26/16.
//  Copyright © 2016 Delaney Giacalone. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var currentDay = CurrentDay()
    var tenDays = [TenDay]()
    let color = UIColor(red: 171/255, green: 219/255, blue: 234/255, alpha: 0.5)
    
    let apiString10DayForecast = "https://api.wunderground.com/api/ee93484780c7d874/forecast10day/q/CA/San_Luis_Obispo.json"
    let apiStringConditions = "https://api.wunderground.com/api/ee93484780c7d874/conditions/q/CA/San_Luis_Obispo.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentWeather()
        get10DayForecast()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tenDays.count + 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "CurrentDayCell", for: indexPath) as! CurrentDayCell
            cell.backgroundColor = color
            (cell as! CurrentDayCell).cityLabel.text = currentDay.city
            (cell as! CurrentDayCell).currentConditionsLabel.text = currentDay.currentConditions
            (cell as! CurrentDayCell).dayLabel.text = currentDay.dayofWeek
            if currentDay.windSpeed == -1 {
                (cell as! CurrentDayCell).tempLabel.text = ""
                (cell as! CurrentDayCell).highLowLabel.text = ""
                (cell as! CurrentDayCell).windLabel.text = ""
            }
            else {
                (cell as! CurrentDayCell).tempLabel.text = "\(currentDay.temp)°"
                (cell as! CurrentDayCell).highLowLabel.text = "\(currentDay.dailyHigh)°   \(currentDay.dailyLow)°"
                (cell as! CurrentDayCell).windLabel.text = "\(currentDay.windSpeed) mph \(currentDay.windDirection)"
            }
            
        }
        else{
            cell = tableView.dequeueReusableCell(withIdentifier: "OtherDayCell", for: indexPath) as! OtherDayCell
            cell.backgroundColor = color
            if tenDays.count >= indexPath.row {
                (cell as! OtherDayCell).dayLabel.text = tenDays[indexPath.row-1].dayOfWeek
                (cell as! OtherDayCell).forecastLabel.text = tenDays[indexPath.row-1].forecast
                (cell as! OtherDayCell).highLowLabel.text = "\(tenDays[indexPath.row-1].dailyHigh)°   \(tenDays[indexPath.row-1].dailyLow)°"
                (cell as! OtherDayCell).popLabel.text = "\(tenDays[indexPath.row-1].pop)%"
            }
            
        }

        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row == 0)
        {
            return 300
        }
        else{
            return 100
        }
    }
    
    func getCurrentWeather() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let request = NSURLRequest(url: NSURL(string: apiStringConditions)! as URL)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                var jsonResponseCurrent : [String:AnyObject]?
                do {
                    jsonResponseCurrent = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                }
                catch {
                    print("Caught exception")
                }
                
                let dictionary = jsonResponseCurrent?["current_observation"]
                let displayLocation = dictionary?["display_location"] as? [String: String]
                let city = displayLocation?["city"]
                self.currentDay.city = city!
                
                //get conditions
                let conditions = dictionary?["weather"] as! String
                self.currentDay.currentConditions = conditions
                
                //get temperature
                let temp = dictionary?["temp_f"] as! Int
                self.currentDay.temp = temp
                
                //get wind dir/speed
                let windSpeed = dictionary?["wind_mph"] as! Int
                self.currentDay.windSpeed = windSpeed
                let windDir = dictionary?["wind_dir"] as! String
                self.currentDay.windDirection = windDir
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }
        task.resume()
        
    }
    
    func get10DayForecast() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let request = NSURLRequest(url: NSURL(string: apiString10DayForecast)! as URL)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                var jsonResponse : [String:AnyObject]?
                do {
                    jsonResponse = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                }
                catch {
                    print("Caught exception")
                }
                
                //fill in rest of current weather
                let dictionary = jsonResponse?["forecast"]
                let simpleForecast = dictionary?["simpleforecast"] as! [String:Any]
                let forecastDay = simpleForecast["forecastday"] as! [[String:Any]]
                var date = forecastDay[0]["date"] as! [String: Any]
                var dayOfWeek = date["weekday"] as! String
                self.currentDay.dayofWeek = dayOfWeek
                
                var high = forecastDay[0]["high"] as! [String : Any]
                var highF = high["fahrenheit"] as! String
                self.currentDay.dailyHigh = Int(highF)!
                
                var low = forecastDay[0]["low"] as! [String : Any]
                var lowF = low["fahrenheit"] as! String
                self.currentDay.dailyLow = Int(lowF)!
                
                let numDays = forecastDay.count-1
                //fill in next ten days
                for index in 1...numDays {
                    //day of week
                    date = forecastDay[index]["date"] as! [String: Any]
                    dayOfWeek = date["weekday"] as! String
                    
                    //forecast
                    let condition = forecastDay[index]["conditions"] as! String
                    
                    //high/low
                    high = forecastDay[index]["high"] as! [String: Any]
                    highF = high["fahrenheit"] as! String
                    low = forecastDay[index]["low"] as! [String: Any]
                    lowF = low["fahrenheit"] as! String
                    
                    //percent chance of rain
                    let pop = forecastDay[index]["pop"] as! Int
                    
                    //create TenDay
                    let tenDay = TenDay()
                    tenDay.dayOfWeek = dayOfWeek
                    tenDay.forecast = condition
                    tenDay.dailyHigh = Int(highF)!
                    tenDay.dailyLow = Int(lowF)!
                    tenDay.pop = pop
                    self.tenDays.append(tenDay)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()

    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "CurrentToHour" || segue.identifier == "DayToHour"
        {
            let destVC = segue.destination as? HourlyTableViewController
            destVC?.daySelected = tableView.indexPathForSelectedRow?.row
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    

}
