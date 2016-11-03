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
    let hour = Hour()
    
    var daySelected : Int?
    
    let apiStringHourlyForecast = "https://api.wunderground.com/api/ee93484780c7d874/hourly10day/q/CA/San_Luis_Obispo.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        hours.append(hour)
        
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
                
                /*let dictionary = jsonResponseCurrent?["current_observation"]
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
                self.currentDay.windDirection = windDir*/
                
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
