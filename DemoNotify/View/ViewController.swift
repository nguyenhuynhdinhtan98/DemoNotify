//
//  ViewController.swift
//  DemoNotify
//
//  Created by Tân Nguyễn on 31/03/2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNService.shared.authorize()
        CLService.shared.authorize()
        NotificationCenter.default.addObserver(self, selector: #selector(onLocationTapped), name: NSNotification.Name("internalNotification.enteredRegion"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAction), name: NSNotification.Name("internalNotification.handleAction"), object: nil)
        
    }
    
    @IBAction func onTimerTapped() {
        AlertService.actionSheets(in: self, title: "2s") {
            UNService.shared.timerRequest(with: 2)
        }
        
    }
    
    @IBAction func onDateTapped() {
        AlertService.actionSheets(in: self, title: "Some future time") {
            var date = DateComponents()
            date.second = 0
            UNService.shared.dateRequest(with: date)
        }
        
    }
    
    @IBAction func onLopcationTapped() {
        AlertService.actionSheets(in: self, title: "Updating location") {
            CLService.shared.updateLocation()
        }
    }
    
    @objc func onLocationTapped() {
        UNService.shared.locationRequest()
    }
    
    @objc func handleAction(_ sender: Notification) {
        guard let action = sender.object as? NotifyActionID else { return }
        switch action {
        case.timer: print("Timer action")
        case.date: print("Date action")
        case.location: print("Location action")
        }
    }
}

