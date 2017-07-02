//
//  ViewController.swift
//  MovieReviewiOS
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var reviewTextField: UITextView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var ratingsSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reviewTextField.delegate = self
        createUserActivity()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
//        print(sender.value)
        let roundedRating = String(format: "%.1f", sender.value)
        ratingsLabel.text = "Rating: \(roundedRating)"
        userActivity?.needsSave = true
    }
    
    func createUserActivity() {
        let activity = NSUserActivity(activityType: "com.kay.movieReview.createReview")
        activity.title = "Creating Review"
        var reviewDictionary : [AnyHashable : Any]? = [:]
        reviewDictionary?["title"] = nameTextField.text
        reviewDictionary?["reviewText"] = reviewTextField.text
        reviewDictionary?["rating"] = ratingsSlider.value
        activity.userInfo = reviewDictionary
        
        self.userActivity = activity
        self.userActivity?.becomeCurrent()
    }
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        var reviewDictionary : [AnyHashable : Any] = [:]
        reviewDictionary["title"] = nameTextField.text
        reviewDictionary["reviewText"] = reviewTextField.text
        reviewDictionary["rating"] = ratingsSlider.value
        activity.userInfo = reviewDictionary
        print("asked for update")
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        userActivity?.needsSave = true
        print("text field name changed")
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        userActivity?.needsSave = true
        print("text view changed")
    }
}

