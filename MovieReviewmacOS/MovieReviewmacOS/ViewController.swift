//
//  ViewController.swift
//  MovieReviewmacOS
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var reviewTextField: NSTextField!
    @IBOutlet weak var slider: NSSlider!
    @IBOutlet weak var ratingsLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserActivity()
        titleTextField.delegate = self
        reviewTextField.delegate = self
    }

    override func restoreUserActivityState(_ userActivity: NSUserActivity) {
        print("we are restoring")
        if let title = userActivity.userInfo?["title"] as? String {
            titleTextField.stringValue = title
        }
        if let reviewText = userActivity.userInfo?["reviewText"] as? String {
            reviewTextField.stringValue = reviewText
        }
        if let rating = userActivity.userInfo?["rating"] as? Float {
            slider.floatValue = rating
            let roundedRating = String(format: "%.1f", rating)
            ratingsLabel.stringValue = "Rating: \(roundedRating)"
        }
        
        
    }
    
    func createUserActivity() {
        let activity = NSUserActivity(activityType: "com.kay.movieReview.createReview")
        activity.title = "Creating Review"
        var reviewDictionary : [AnyHashable : Any]? = [:]
        reviewDictionary?["title"] = titleTextField.stringValue
        reviewDictionary?["reviewText"] = reviewTextField.stringValue
        reviewDictionary?["rating"] = slider.floatValue
        activity.userInfo = reviewDictionary
        
        self.userActivity = activity
        self.userActivity?.becomeCurrent()
    }
    
    
    override func updateUserActivityState(_ userActivity: NSUserActivity) {
        var reviewDictionary : [AnyHashable : Any] = [:]
        reviewDictionary["title"] = titleTextField.stringValue
        reviewDictionary["reviewText"] = reviewTextField.stringValue
        reviewDictionary["rating"] = slider.floatValue
        userActivity.userInfo = reviewDictionary
        print("asked for update from Mac")
    }
    
    @IBAction func sliderChanged(_ sender: NSSlider) {
        userActivity?.needsSave = true
    }
    
    
    override func controlTextDidChange(_ obj: Notification) {
        print("did change text")
        userActivity?.needsSave = true
    }
    
    
}

