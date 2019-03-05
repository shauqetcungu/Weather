//
//  SecondViewController.swift
//  Weather
//
//  Created by Administrator on 25/02/2019.
//  Copyright © 2019 Amplitudo. All rights reserved.
//

import UIKit
import Moya
import Kingfisher

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var weatherTable: UITableView!
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherTable.rowHeight = 100;
        moyaCall()
        weatherTable.dataSource = self
        weatherTable.delegate = self
        self.weatherTable.reloadData()
    }
    
    private var lists : [List] = []
    var sections = [[List]]()
    
    func moyaCall(){
        let provider = MoyaProvider<Vrijeme>()
        provider.request(.vrijeme) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let decoded = try? JSONDecoder().decode(Welcome.self, from: data)
                    DispatchQueue.main.async {
                        self.lists=(decoded?.list)!
                        self.sectionsWeather()
                        self.weatherTable.reloadData()
                        self.title = decoded?.city?.name ?? "N/A"
                    }
            case let .failure(error):
            print(error)
            }
        }
    }
    
    func sectionsWeather(){
        if self.lists.count > 0 {
            var prvi = lists[0]
            self.sections.append([prvi])
            
            lists.forEach { (List) in
                if Calendar.current.isDate(List.getDate(), inSameDayAs: prvi.getDate()) {
                    self.sections[self.sections.count - 1].append(List)
                }
                else {
                    self.sections.append([List])
                    prvi = List
                }
            }
        }
        else{
            self.sections = []
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = self.sections[section][0].getDate()
        if Calendar.current.isDate(date, inSameDayAs: currentDate) {
            return "Today"
        }
        else{
            return dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date)-1]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell{
            let vrijeme = self.sections[indexPath.section][indexPath.row]
            cell.updateVrijeme(vrijeme: vrijeme)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
}
