//
//  RideListCardViewController.swift
//  Thesis1
//
//  Created by Zain Sohail on 05.04.20.
//  Copyright © 2020 Zain Sohail. All rights reserved.
//

import UIKit
protocol RideListProtocol{
    func  collapseList()
    
    func selectedRide(selectedRide: String)
}

protocol SortProtocol{
    func  sortRideList()
}


class RideListCardViewController: UIViewController {
    
    @IBOutlet weak var handleArea: UIView!
    var rideTypeTableView = UITableView()
    var rides: [Ride] = []
    var isTableViewInitialised = false
    var rideListDelegate: RideListProtocol!
    var sortDelegate: SortProtocol!
    var selectedRide: Ride!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    func setupElements(){
        view.addSubview(rideTypeTableView)
        
        rideTypeTableView.delegate = self
        rideTypeTableView.dataSource = self
        rideTypeTableView.rowHeight = 80
        rideTypeTableView.register(RidesTableViewCell.self, forCellReuseIdentifier: "RideCell")
        rideTypeTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
        rideTypeTableView.delegate?.tableView?(rideTypeTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        setTableViewConstraints()
        isTableViewInitialised = true
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        sortDelegate.sortRideList()
    }
    
    func setTableViewConstraints(){
        rideTypeTableView.translatesAutoresizingMaskIntoConstraints = false
        rideTypeTableView.topAnchor.constraint(equalTo: handleArea.bottomAnchor, constant: 0).isActive = true
        rideTypeTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        rideTypeTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        rideTypeTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }
    
    func fetchData(){
        DefaultAPI.getvehiclesGet(latOrg: originLat, lngOrg: originLong, seats: 1, walkingDistance: Int(selectedDistance)) {(RideTypesResponse,Error) in
            for i in 0...RideTypesResponse!.count-1 {
                switch RideTypesResponse![i].rideType!.rawValue{
                case "express":
                    self.rides.append(Ride(image: UIImage(named: "Express")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                case "comfort":
                    self.rides.append(Ride(image: UIImage(named: "Comfort")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                case "luxury":
                    self.rides.append(Ride(image: UIImage(named: "Luxury")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                case "electric":
                    self.rides.append(Ride(image: UIImage(named: "Electric")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                case "suv_express":
                    self.rides.append(Ride(image: UIImage(named: "suvExpress")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                case "suv_comfort":
                    self.rides.append(Ride(image: UIImage(named: "suvComfort")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                case "suv_luxury":
                    self.rides.append(Ride(image: UIImage(named: "suvLuxury")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                case "suv_electric":
                    self.rides.append(Ride(image: UIImage(named: "suvElectric")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                case "wav":
                    self.rides.append(Ride(image: UIImage(named: "WAV")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                default:
                    self.rides.append(Ride(image: UIImage(named: "Express")!, rideType: RideTypesResponse![i].displayName!, price: RideTypesResponse![i].price!, eta: RideTypesResponse![i].eta!, pickupTime: RideTypesResponse![i].pickup!))
                }
            }
            self.setupElements()
        }
    }
}

extension RideListCardViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RideCell", for: indexPath) as! RidesTableViewCell
        let ride = rides[indexPath.row]
        cell.set(ride: ride)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        selectedRide = rides[indexPath.row]
        rideListDelegate!.selectedRide(selectedRide: selectedRide.rideType)
        if(isTableViewInitialised == true){
            rideListDelegate!.collapseList()
            tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }
    }
}
