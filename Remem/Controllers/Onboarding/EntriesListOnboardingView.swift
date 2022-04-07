//
//  ViewOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

class EntriesListOnboardingView: OnboardingView {
    lazy var labelMyNameIs: UILabel = {
        let label = createLabel()
        label.text = "I am tracking app called Remem and I am designed to help you to answer following questions:"
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelQuestion01: UILabel = {
        let label = createLabel()
        label.text = "- when did an event last happened?"
        label.topAnchor.constraint(equalTo: labelMyNameIs.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelQuestion02: UILabel = {
        let label = createLabel()
        label.text = "- how many events happen in a week?"
        label.topAnchor.constraint(equalTo: labelQuestion01.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelHint: UILabel = {
        let label = createLabel()
        label.text = "You can use me to track things like smoking a cigarette, drinking cup of coffee, doing morning exercises or taking pills. Whatever periodic event you want to track exactly"
        label.topAnchor.constraint(equalTo: labelQuestion02.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelStart: UILabel = {
        let label = createLabel()
        label.text = "Start is easy. Swipe up the screen to create an event"
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelEventName: UILabel = {
        let label = createLabel()
        label.text = "Give it a name. Using emojis is encouraged!"
        return label
    }()
    
    lazy var labelEventCreated: UILabel = {
        let label = createLabel()
        label.text = "Since that moment I can record each time this event happens, but not without your help, of course."
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelEventSwipe: UILabel = {
        let label = createLabel()
        label.text = "You do the job of notifying me by swiping a circle, just like accepting a call. Try it"
        label.topAnchor.constraint(equalTo: labelEventCreated.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelSwipeComplete: UILabel = {
        let label = createLabel()
        label.text = "Nice! Now I will Remember that moment in time and let you review it later. Do it couple more times to get used to it"
        label.topAnchor.constraint(equalTo: labelEventSwipe.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelAdditionalSwipes: UILabel = {
        let label = createLabel()
        label.text = "2 / 5"
        label.topAnchor.constraint(equalTo: labelSwipeComplete.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelTestItemDescription: UILabel = {
        let label = createLabel()
        label.text = "Now let`s assume that you have been using me for some time. You will receive something like that"
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelTestItemLongPress: UILabel = {
        let label = createLabel()
        label.text = "Tap the circle to view details"
        label.topAnchor.constraint(equalTo: labelTestItemDescription.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
}
