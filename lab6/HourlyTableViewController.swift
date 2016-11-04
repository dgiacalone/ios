//
//  HourlyTableViewController.swift
//  lab6
//
//  Created by Delaney Giacalone on 11/2/16.
//  Copyright © 2016 Delaney Giacalone. All rights reserved.
//

import UIKit

class HourlyTableViewController: UITableViewController {

    var hours = [Hour]()
    
    var daySelected : Int?
    
    let apiStringHourlyForecast = "https://api.wunderground.com/api/ee93484780c7d874/hourly10day/q/CA/San_Luis_Obispo.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        getHourlyWeather()
        
        print("daySelected: \(daySelected)")

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
        return hours.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourCell", for: indexPath) as! HourCell
        if hours.count >= indexPath.row {
            cell.dayLabel.text = hours[indexPath.row].dayOfWeek
            cell.dateLabel.text = hours[indexPath.row].date
            cell.hourLabel.text = String(hours[indexPath.row].hour)
            cell.windLabel.text = "\(hours[indexPath.row].windSpeed) mph wind"
            cell.tempLabel.text = "\(hours[indexPath.row].temp)°"
            cell.popLabel.text = "\(hours[indexPath.row].pop)% chance of rain"
        }
        return cell
    }
    
    func getHourlyWeather() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let request = NSURLRequest(url: NSURL(string: apiStringHourlyForecast)! as URL)
        
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let data = data {
                var jsonResponseCurrent : [String:AnyObject]?
                do {
                    jsonResponseCurrent = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                }
                catch {
                    print("Caught exception")
                }
                
                var count = 0
                let hourlyForecast = jsonResponseCurrent?["hourly_forecast"] as! [AnyObject]
                for index in 0...hourlyForecast.count {
                    let indexedHour = hourlyForecast[index] as! [String:AnyObject]
                    let fcttime = indexedHour["FCTTIME"] as! [String:AnyObject]
                    let hour = Int(fcttime["hour"] as! String)
                    if hour == 0 {
                        count += 1
                    }
                    if count == self.daySelected {
                        //var prevIndex = -1
                        for index2 in 0...23 {
                            let indexedHour = hourlyForecast[index+index2] as! [String:AnyObject]
                            let fcttime = indexedHour["FCTTIME"] as! [String:AnyObject]
                            let thisHour = Int(fcttime["hour"] as! String)!
                            
                            //print("prevIndex: \(prevIndex))
                            //make sure api has no repeats
                            /*if prevIndex == thisHour {
                                continue
                            }*/
                            //get weekday
                            let weekdayName = fcttime["weekday_name"] as! String
                            //get date
                            let month = fcttime["mon_abbrev"] as! String
                            let day = fcttime["mday"] as! String
                            let date = "\(month) \(day)"
                            //get wind
                            let wspd = indexedHour["wspd"] as! [String:AnyObject]
                            let windEnglish = Int(wspd["english"] as! String)!
                            //get temp
                            let temp = indexedHour["temp"] as! [String:AnyObject]
                            let tempEnglish = Int(temp["english"] as! String)!
                            //get PoP
                            let pop = Int(indexedHour["pop"] as! String)!
                            
                            //create hour
                            let newHour = Hour()
                            //newHour.hour = index2
                            newHour.hour = thisHour
                            newHour.dayOfWeek = weekdayName
                            newHour.date = date
                            newHour.windSpeed = windEnglish
                            newHour.temp = tempEnglish
                            newHour.pop = pop
                            self.hours.append(newHour)
                            
                            //prevIndex = thisHour
                        }
                        break
                    }
                    
                }
                /*let first = hourlyForecast[0] as! [String:AnyObject]
                let fcttime = first["FCTTIME"] as! [String:AnyObject]
                let firstHour = fcttime["hour"] as! String
                print("firstHour: \(firstHour)")
                
                let currentHoursLeft = 24-Int(firstHour)!
                let arrayIndex = currentHoursLeft + (self.daySelected!*24)
                print("arrayIndex \(arrayIndex)")*/
                
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
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    

}
