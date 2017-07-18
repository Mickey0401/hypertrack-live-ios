//
//  ViewController.swift
//  htlive-ios
//
//  Created by Vibes on 7/4/17.
//  Copyright © 2017 PZRT. All rights reserved.
//

import UIKit
import HyperTrack
import FSCalendar

class ViewController: UIViewController {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var placeLineTable: UITableView!
    var segments: [HyperTrackActivity] = []
    
    @IBOutlet weak var calendarArrow: UIImageView!
    @IBAction func calendarTap(_ sender: Any) {
        
        guard calendarTop.constant != 0 else {
            calendarTop.constant = -300
            
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.calendar.layer.opacity = 0
                self.calendarArrow.transform = self.calendarArrow.transform.rotated(by: CGFloat(Double.pi))
            })
            return
        }
        
        calendarTop.constant = 0
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.calendar.layer.opacity = 1
            self.calendarArrow.transform = self.calendarArrow.transform.rotated(by: CGFloat(-Double.pi))
        })
        
    }
    
    @IBOutlet weak var calendarTop: NSLayoutConstraint!
    
    @IBAction func onLiveLocationButtonClick(sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let liveLocationController = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        self.present(liveLocationController, animated:true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendarTop.constant = -300
        calendar.layer.opacity = 0
        
        placeLineTable.register(UINib(nibName: "placeCell", bundle: nil), forCellReuseIdentifier: "placeCell")
        
        HyperTrack.getPlaceline { (placeLine, error) in
            guard let fetchedPlaceLine = placeLine else { return }
            if let segments = fetchedPlaceLine.segments {
                    self.segments = segments
                    self.placeLineTable.reloadData()
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segments.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 72
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! placeCell
        cell.layer.backgroundColor = UIColor.clear.cgColor
        if segments.count != 0 {
                cell.setStats(activity: segments[indexPath.row])
            }
        return cell
        
    }
}


extension ViewController : FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }

}


