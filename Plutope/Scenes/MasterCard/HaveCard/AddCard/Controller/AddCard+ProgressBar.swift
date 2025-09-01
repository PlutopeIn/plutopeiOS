//
//  AddCard+ProgressBar.swift
//  Plutope
//
//  Created by Priyanka Poojara on 01/08/23.
//

import UIKit
import ABSteppedProgressBar

extension AddCardDetailViewController: ABSteppedProgressBarDelegate {

    internal func configureProgressBar() {
        // Customise the progress bar here
        self.progressBar.numberOfPoints = 4
        self.progressBar.lineHeight = 4
        self.progressBar.radius = 4
        self.progressBar.progressRadius = 4
        self.progressBar.progressLineHeight = 12
        
        self.progressBar.currentIndex = Step.personalDetails.rawValue
        self.progressBar.delegate = self
        
        self.progressBar.stepTextColor = UIColor.clear
        
        self.progressBar.backgroundShapeColor = UIColor.c25264D
        self.progressBar.selectedBackgoundColor = UIColor.c00C6FB
    }
    
    internal func addSubtitles() {
        let subtitleVerticalPosition: CGFloat = progressBar.frame.origin.y + progressBar.bounds.height + 5
        for (idx, point) in progressBar.centerPoints.enumerated() {
            let realPoint = progressBar.convert(point, to: view)
            let subtitle = UILabel(frame: CGRect(x: 0, y: subtitleVerticalPosition, width: (screenWidth / CGFloat(progressBar.numberOfPoints)) - 10, height: subtitleHeight))
            subtitle.textAlignment = .center
            subtitle.textColor = UIColor.white
            subtitle.center.x = realPoint.x
            subtitle.numberOfLines = 0
            subtitle.font = AppFont.medium(subtitleFontSize).value
            subtitle.text = Step(rawValue: idx)?.title ?? ""
            view.addSubview(subtitle)
        }
    }
    
    func progressBar(_ progressBar: ABSteppedProgressBar, canSelectItemAtIndex index: Int) -> Bool {
        print("progressBar:canSelectItemAtIndex:\(index)")
        // Only next (or previous) step can be selected
        let offset = abs(progressBar.currentIndex - index)
        return (offset <= 1)
    }
    
    func progressBar(_ progressBar: ABSteppedProgressBar, textAtIndex index: Int) -> String {
        if let step = Step(rawValue: index) {
            print("progressBar:textAtIndex:\(index)")
            return step.title
        }
        return ""
    }
}
