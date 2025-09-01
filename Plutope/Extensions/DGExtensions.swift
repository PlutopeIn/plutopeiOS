//
//  DGExtensions.swift
//
//  Total Extensions: 80+
//
//  Created by Dhruv Govani on 27/06/20.
//
//  GIT: https://github.com/DhruvGovani/SwiftExtensions
//  Readme: https://github.com/DhruvGovani/SwiftExtensions/blob/master/README.md
/**
 Copyright (c) 2020 Dhruv Govani
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */
import Foundation
import UIKit
import WebKit
enum Location {
    case left, right
}
enum ShowStyle {
    case Push, Present
}
enum DateTimeZone {
    case Local, UTC
}
enum GradientDirection{
    case Horizontal
    case Vertical
    case Diagonal
}
enum Corners{
    case TopLeft
    case TopRight
    case BottomLeft
    case BottomRight
}
extension UIView {
    
    enum AnimationType{
        case CrossDissolve
        case ScaleDissolve
    }
    
    enum RotationAngle{
        case DownSideUp
        case LeftFlip
        case RightFlip
        case UpSideDown
        case Original
    }
    
    func Rotate(by: RotationAngle) {
        switch by {
        case .DownSideUp:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        case .LeftFlip:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        case .RightFlip:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double.pi / 2)))
        case .UpSideDown:
            self.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double.pi)))
        case .Original :
            self.transform =  CGAffineTransform(rotationAngle: 0)
        }
    }
    
    func Hide(animated Animation: AnimationType) {
        self.isUserInteractionEnabled = false
        switch Animation{
            
        case .CrossDissolve:
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0
            }
        case .ScaleDissolve:
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alpha = 1
            
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.alpha = 0
            }
        }
        
    }
    
    func Show(animated Animation: AnimationType) {
        self.isUserInteractionEnabled = true
        switch Animation{
        case .CrossDissolve:
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1
            }
        case .ScaleDissolve:
            self.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            self.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.alpha = 1
            }
        }
    }
    
    ///Round the edges of all views defined in parameter
    /// # Usage :
    ///    UIView().RoundEdgesOf(Views: [Label,TextField,Button,SubView])
    /// - parameter Views: List of UIView you wanted to round edges of
    func RoundEdgesOf(Views: [UIView], Radius: CGFloat?) {
        
        for i in Views{
            i.clipsToBounds = true
            i.layer.cornerRadius = Radius ?? i.frame.height / 2
        }
        
    }
    
    /// Give same border to all views being mentioned
    /// # Usage:
    ///     UIView().GiveBorderTo(Views: [Label,TextField,Button,SubView],borderColor: .black, borderWidth: 1 )
    /// - parameter Views: List of view to apply border
    /// - parameter borderColor: color of border
    /// - parameter borderWidth: width of border
    func GiveBorderTo(Views: [UIView], borderColor: UIColor, borderWidth: CGFloat) {
        
        for i in Views{
            i.layer.borderWidth = borderWidth
            i.layer.borderColor = borderColor.cgColor
        }
    }
    
    ///Round the edges of all view
    func RoundMe(Radius: CGFloat?) {
        self.clipsToBounds = true
        self.layer.cornerRadius = Radius ?? self.frame.height / 2
    }
    /// This function will add an additional border near the View's frame
    /// - mostly useful when you wanted to show the border around view with little bit space
    /// - note: Formula For Rounded Border: YourMainView.frame.height + width + spacing / 2
    /// - parameter width: width of the border
    /// - parameter Spacing: spacing between border and your view
    /// - parameter CornderRadius: Corner radius for Border
    /// - parameter BorderColor: Color of border
    
    
    func DGBorderView(width: CGFloat, Spacing: CGFloat, CornderRadius: CGFloat?, BorderColor: UIColor?) {
        
        let DGBorderView = UIView(frame: .zero)
        
        DGBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        DGBorderView.clipsToBounds = true
        
        if let ParentView = self.superview {
            
            if let index =  ParentView.subviews.firstIndex(of: self) {
                ParentView.insertSubview(DGBorderView, at: index)
            } else {
                ParentView.addSubview(DGBorderView)
                ParentView.sendSubviewToBack(DGBorderView)
            }
            
            NSLayoutConstraint.activate([
                DGBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: -(Spacing)),
                DGBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -(Spacing)),
                DGBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: (Spacing)),
                DGBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: (Spacing))
            ])
            
            if let color = BorderColor{
                DGBorderView.layer.borderColor = color.cgColor
            }
            
            if let radius = CornderRadius{
                DGBorderView.layer.cornerRadius = radius
            }
            
            DGBorderView.layer.borderWidth = width
        }
        
    }
    
    /// It will return the Current X and  Y of  the UIView
    var globalPoint :CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    /// It will return the Current X , Y, H, and W of the UIView
    var globalFrame :CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
    ///This function will give the border to the view.
    /// - parameter Color: Color of the border
    /// - parameter BorderWidth: Width of the border you want
    func BorderMe(Color: UIColor, BorderWidth: CGFloat) {
        self.layer.borderColor = Color.cgColor
        self.layer.borderWidth = BorderWidth
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    ///This Function will drop a shadow for the view based on the provided input
    /// - parameter ShadowColor: Color of shadow
    /// - parameter radius: radius of shadow
    /// - parameter Height: Vertical weight
    /// - parameter Width: Horizontal weight
    /// - parameter Opacity: Opciity of shadow
    /// - parameter CornerRadius: radius of corners of shadow
    func dropShadow(ShadowColor: UIColor, radius: CGFloat, Height: CGFloat, Width: CGFloat, Opacity: Float, CornerRadius: CGFloat) {
        
        if CornerRadius > 0{
            self.layer.cornerRadius = CornerRadius
        }
        
        self.layer.shadowColor = ShadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: Width, height: Height)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = Opacity
        self.layer.masksToBounds = false;
        
        
    }
    
    ///This Function vill add gradient layer at ) index of the UIView
    /// - colors will be in sequence provided index vise
    /// - parameter Direction: Direction will define the direction of gradient flow
    /// - parameter Colors: Array of CGColors You wanted to make garient of
    func GradientView(Direction: GradientDirection, Colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = Colors
        gradientLayer.cornerRadius = self.layer.cornerRadius
        
        if Direction == .Horizontal{
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        } else if Direction == .Vertical{
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func MakeGradientLayer(Direction: GradientDirection, Colors: [CGColor]) -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = Colors
        gradientLayer.cornerRadius = self.layer.cornerRadius
        
        if Direction == .Horizontal{
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        } else if Direction == .Vertical{
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        }
        
        gradientLayer.frame = self.bounds
        
        return gradientLayer
    }
    
    /// returns the superview of the view
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: type) }
    }
    
    /**
     Function will shake the viwe with a vibration
     - parameters:
     - Vibrate: Bool value to vibrate the device or not
     - speed: Speed of the shake
     - completion: if you want something to do after shake completed
     */
    
    
    func shake(Vibrate: Bool,speed: Double?,completion: (() -> Void)? = nil) {
        let speed = speed ?? 0.75
        let time = 1.0 * speed - 0.15
        let timeFactor = CGFloat(time / 4)
        let animationDelays = [timeFactor, timeFactor * 2, timeFactor * 3]
        let shakeAnimator = UIViewPropertyAnimator(duration: time, dampingRatio: 0.3)
        // left, right, left, center
        shakeAnimator.addAnimations({
            self.transform = CGAffineTransform(translationX: 10, y: 0)
        })
        shakeAnimator.addAnimations({
            self.transform = CGAffineTransform(translationX: -10, y: 0)
        }, delayFactor: animationDelays[0])
        shakeAnimator.addAnimations({
            self.transform = CGAffineTransform(translationX: 10, y: 0)
        }, delayFactor: animationDelays[1])
        shakeAnimator.addAnimations({
            self.transform = CGAffineTransform(translationX: 0, y: 0)
        }, delayFactor: animationDelays[2])
        shakeAnimator.startAnimation()
        shakeAnimator.addCompletion { _ in
            completion?()
        }
        shakeAnimator.startAnimation()
        if Vibrate{
            UIViewController().VibratePhone(Hardness: .low)
        }
    }
}
extension String{
    ///This will return the substring after the occurance of specfied character
    /// - parameter after: specify the Character which will provide the substring after its occurance
    /// - this will return substring of type String
    /// - returns: Substring after the occuarance of current string
    func getSubstring(after: String) -> String{
        
        if let range = self.range(of: after) {
            let substring = self[range.upperBound...]
            return String(substring)
        } else {
            return self
        }
        
    }
    var underLined: NSAttributedString {
            NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        }
    /// you can use this function to check the email is valid or invalid
    var isValidEmail: Bool {
               NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
           }
    /// returns the boolean value telling if string contains the whitespace or not
    var containsWhitespace: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x20:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// This function will remove all the white space and new lines  from trailing or leading of the text inside of the textview
    /// - user it inside end editing of text field or textview for best result
    mutating func removeWhiteSpacesNearMe() {
        let trimmedText = self.trimmingCharacters(in: .whitespacesAndNewlines)
        self = trimmedText
    }
    
    /// This function will convert the string date to a perticular format and will return the output in both string and date.
    /// # Functionalties:
    /// 1.  Convert String date to any format
    /// 2.  Convert date and 12Hout to 24Hour just use perfect format from above
    /// 3.  Convert date with time zone by providing which timeZone you wanted the output in.
    /// 4.  Returns output in both String and Date
    /// - parameter currentFormat: Current format of the date
    /// - parameter toFormat: output format of the date
    /// - parameter timeZone: The Output timezone of the date
    /// - returns: String and Date both output will be given. use Dot operator to access any (.)
    /// # Formats:
    /// # 08 - (Only Last two digit of Year)
    ///     "yy"
    /// # 2008 - (Whole length of Year)
    ///     "yyyy"
    /// # 12 - (Simple Single/double digit of year. e.g: 1,2,3...9,10,11)
    ///     "M"
    /// # 12 - (Simple double digit of Year, e.g: 01,02..12)
    ///     "MM"
    /// # Dec - (Initial human readable word of Year)
    ///     "MMM"
    /// # December - (full HR word of Year)
    ///     "MMMM"
    /// # D - (Single letter of Year)
    ///     "MMMMM"
    /// # 1 - (Single digit date of Date e.g: 1,2,3.......,29,30)
    ///     "d"
    /// # 01 - (Double digit of Date e.g: 01,02,03.......,29,30)
    ///     "dd"
    /// # 3rd Tuesday in December - (Total Human redable with day of a date)
    ///     "F"
    /// # Tues - (day intial of day of the date)
    ///     "E"
    /// # Tuesday - (day full)
    ///     "EEEE"
    /// # T - (day single intial)
    ///     "EEEEE"
    /// # 4 - (12 hour in single digit)
    ///     "h"
    /// # 04 - (12 hour in two digit)
    ///     "hh"
    /// # 16 - (24 hour in single digit)
    ///     "H"
    /// # 16 - (24 hour in two digit)
    ///     "HH"
    /// # AM/PM - (Meriediem)
    ///     "a"
    /// # CST :  The 3 letter name of the time zone. Falls back to GMT-08:00 (hour offset) if the name is not known.
    ///     "zzz"
    /// # Central Standard Time : The expanded time zone name, falls back to GMT-08:00 (hour offset) if name is not known.
    ///      "zzzz"
    /// # CST-06:00 : Time zone with abbreviation and offset
    ///      "zzzz"
    /// # -0600 :  RFC 822 GMT format. Can also match a literal Z for Zulu (UTC) time.
    ///     "Z"
    /// # -06:00
    ///     "ZZZZZ"
    
    
    func ConvertDate(currentFormat: String, toFormat: String, timeZone: DateTimeZone?) ->  (String,Date) {
        let dateFormator = DateFormatter()
        dateFormator.locale = Locale(identifier: "en_US_POSIX")
        dateFormator.dateFormat = currentFormat
        switch timeZone {
        case .Local:
            dateFormator.timeZone = TimeZone(abbreviation: "UTC")
        case .UTC:
            dateFormator.timeZone = TimeZone.current
        case .none:
            break
        }
        
        let resultDate = dateFormator.date(from: self) ?? Date(timeInterval: -3600, since: Date())
        dateFormator.dateFormat = toFormat
        
        switch timeZone {
        case .Local:
            dateFormator.timeZone = TimeZone.current
        case .UTC:
            dateFormator.timeZone = TimeZone(abbreviation: "UTC")
        case .none:
            break
        }
        
        let dateInStr = dateFormator.string(from: resultDate)
        
        if timeZone == .Local{
            dateFormator.timeZone = TimeZone(abbreviation: "UTC")
        }
        
        return (dateInStr , dateFormator.date(from: dateInStr) ?? Date())
    }
    
    /// This function will give you a string which will describe the time difference in human readable form from the today's date
    /// - this functionnis best for post's and commenys
    /// - the output will be both in singular and plural
    /// - parameter currentFormat: Current format of your date
    /// - parameter timeZone: timezone you wanted to be done conversion in
    /// - returns: returns a string with proper time difference explanation
    func getElapsedInterval(currentFormat: String, timeZone: DateTimeZone) -> String {
        
        let fromDate = self.ConvertDate(currentFormat: currentFormat, toFormat: currentFormat, timeZone: timeZone).1
        
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "year ago": "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "month ago": "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            
            return interval == 1 ? "\(interval)" + " " + "day ago": "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "hour ago": "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            
            return interval == 1 ? "\(interval)" + " " + "minute ago": "\(interval)" + " " + "minutes ago"
        }
        
        return "a moment ago"
        
    }
    
    enum TimeDifference {
        case year,month,hour,Minute,Second
    }
    
    /// This function will add the time sepcified difference in given time Date/Time
    /// - this fucntion will calculate the difference based on the all the logical calanderic calculations
    /// - note: If you are getting today's date; bro, something's wrong.
    /// - parameter Step: number of amount of time you want to add
    /// - parameter DifferenceIn: time difference unit
    /// - parameter InputFormat: format of your current date
    /// - parameter OutputFormat: format of output
    /// - returns: Will return string with added time difference
    func AddtimeDifference(Step: Int, DifferenceIn: TimeDifference, InputFormat: String, OutputFormat: String, TimeZone: DateTimeZone?) -> String{
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = InputFormat
        let time = dateFormatter.date(from: self)
        
        var timeInterval = TimeInterval(60)
        
        switch DifferenceIn {
        case .year:
            timeInterval = TimeInterval(31536000 * Step)
        case .month:
            timeInterval = TimeInterval(2628000 * Step)
        case .hour:
            timeInterval = TimeInterval(86399 * Step)
        case .Minute:
            timeInterval = TimeInterval(60 * Step)
        case .Second:
            timeInterval = TimeInterval(1 * Step)
        }
        
        let addedInterval = time?.addingTimeInterval(timeInterval) ?? Date(timeInterval: -3600, since: Date())
        
        dateFormatter.dateFormat = OutputFormat
        let after_add_time = dateFormatter.string(from: addedInterval)
        
        return after_add_time
    }
    
    ///This Function will capitalize the First letter of the string
    /// - returns: string with first capitalize letter
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizeFirstLetter()
    }
    
    /// This function will return the approx height needed by the string to fit in an UILable based on a fixed width
    /// - make sure you provide the perfect font size or greater than the current point for more good output
    /// - parameter width: fix width of the string
    /// - parameter font: font size of the lable
    /// - returns: Will return approx height for the lable
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func WidthWithConstrained(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
    
    ///This function will remove extra new lines from your string
    mutating func removeExtraNewLines() -> String{
        _ = self.trimmingCharacters(in: CharacterSet.newlines)
        // replace occurences within the string
        while let rangeToReplace = self.range(of: "\n\n\n") {
            self.replaceSubrange(rangeToReplace, with: "\n")
        }
        
        return self
    }
    
    /// This function will find the text starts with the char specified and will returns the array of that strings
    /// - parameter Character: a single char to find string with
    /// - parameter removeCharFromResult: if you wanted to remove special char from the resulting array
    /// - returns: Array of String with all matching strings
    func findTextStartsWith(Character: String, removeCharFromResult: Bool) -> [String] {
        var arr_hasStrings:[String] = []
        let Char = Character.first
        let regex = try? NSRegularExpression(pattern: "(\(Char ?? "#")[a-zA-Z0-9_\\p{Arabic}\\p{N}]*)", options: [])
        if let matches = regex?.matches(in: self, options:[], range:NSMakeRange(0, self.count)) {
            for match in matches {
                arr_hasStrings.append(NSString(string: self).substring(with: NSRange(location:match.range.location, length: match.range.length )))
            }
        }
        
        if removeCharFromResult{
            for i in 0..<arr_hasStrings.count{
                arr_hasStrings[i].removeFirst()
            }
        }
        
        return arr_hasStrings
    }
    
    /// This funtion will encode the text for emoji support to sent to server
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    /// This funtion will decode the text for emoji support to display
    func decode() -> String {
        if let data = self.data(using: .utf8) {
            return String(data: data, encoding: .nonLossyASCII) ?? ""
        } else {
            return ""
        }
    }
    
    /// This Function will attribute the color of hashtags in your string and will return NSAttributedString
    /// - supports emoji
    /// - user encode() for converting emojis
    /// - will change the color and also can give line space if not null
    /// - parameter FontColor: Color of the hashtags you want
    /// - parameter lineSpacing: Linespacing you want between lines of text
    func AttributedHashtags(FontColor: UIColor,lineSpacing: CGFloat?) -> NSAttributedString {
        let attrStr = NSMutableAttributedString(string: self.decode())
        let searchPattern = "#\\w+"
        var ranges: [NSRange] = [NSRange]()
        let regex = try! NSRegularExpression(pattern: searchPattern, options: [])
        ranges = regex.matches(in: attrStr.string, options: [], range: NSMakeRange(0, attrStr.string.utf16.count)).map {$0.range}
        for range in ranges {
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: FontColor, range: NSRange(location: range.location, length: range.length))
        }
        
        if let LSpacing = lineSpacing{
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = LSpacing
            
            attrStr.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: NSRange(location: 0, length: attrStr.length
                              ))
        }
        return attrStr
    }
    
    /// This function will convert the String into Dictionary
    /// - returns: will return a Disctionary if conversion is successful
    func stringTodictionary() -> [String:Any]? {
        var dictonary:[String:Any]?
        if let data = self.data(using: .utf8) {
            do {
                dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let myDictionary = dictonary
                {
                    return myDictionary;
                }
            } catch let error as NSError {
                print(error)
            }
        }
        return dictonary;
    }
    
    /// This Function will return the Size of string based on the fonts
    /// - returns: CGSize For the String
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    /// Will return the substring from the defined index
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, self.count) ..< self.count]
    }
    
    /// Will return the substring from 0 to Defined index
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(self.count, r.lowerBound)),
                                            upper: min(self.count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    /// This function will fill your string whenever X is occur
    /// - parameter mask: format of the number ex,: +XX-XXXXX-XXXXX
    /// - make sure your mask length is > then your string to full fill it
    /// - returns: String by replacing all X with the strings
    /// - Usage: "1234567890".toPhoneNumber(mask: "+XX-XXXXX-XXXXX")
    func toPhoneNumber(mask: String) -> String{
        
        let numbers = self
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    /// This function will return a countdown string which will indicate the remaining time to the date from current time and date
    /// - parameter dateFormat: format of your date
    /// - returns: String e.i.: 5 Days 19 Hours
    func RemainingTimeTo(dateFormat: String) -> String{
        
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = dateFormat
        let releaseDate = releaseDateFormatter.date(from:self) ?? Date()
        let date = releaseDateFormatter.date(from: "") ?? Date()
        
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: date, to: releaseDate)
        
        let days = diffDateComponents.day ?? 0
        let hours = diffDateComponents.hour ?? 0
        let mins = diffDateComponents.minute ?? 0
        if days > 0{
            
            if hours > 0{
                return "\(String(days)) days \(String(hours)) hours"
            } else {
                return "\(String(days)) days"
            }
            
        } else {
            
            if hours > 0{
                return "\(String(hours)) hours"
            } else {
                return "\(String(mins)) Minutes"
            }
            
        }
        
    }
    
    /// this function will format your string into a currency format
    /// - parameter fraction: fraction the string after length. default is 2
    /// - returns: Currency formatted string, e.i: 10000 -> 100,000
    func currencyFormatting(fraction: Int?) -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = fraction ?? 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
    
    /// this function will return the NSRange of a string after the occurance of the specified char
    /// - parameter after: char to take range after
    func getRange(after: String) -> NSRange{
        
        var loc = 0
        var len = 0
        var match = false
        
        for i in 0..<self.count{
            if self[i] == after{
                match = true
            } else {
                if match == true{
                    len += 1
                } else {
                    loc += 1
                }
            }
        }
        
        return NSRange(location: loc+1, length: len)
        
    }
        func matches(patternRegex: String?) -> Bool {
            guard let patternRegex = patternRegex else {
                return false // Return false if patternRegex is nil
            }
            
            do {
                let regex = try NSRegularExpression(pattern: patternRegex, options: [])
                let range = NSRange(location: 0, length: self.utf16.count)
                return regex.firstMatch(in: self, options: [], range: range) != nil
            } catch {
                print("Error creating regex: \(error)")
                return false
            }
        }
    

    
}
extension UIButton{
    
    func enableClickEffect() {
        self.setTitleColor(self.titleColor(for: .normal)?.withAlphaComponent(0.5) ?? self.tintColor.withAlphaComponent(0.5), for: .highlighted)
    }
    
    ///This will return the Colorize the button title specfied range
    /// - parameter text: title of your button
    /// - parameter from: Starting position
    /// - parameter length: end position
    /// - parameter color: uicolor for specified title
    /// - this will return substring of type String
    func AttributeMyTitle(_ text:String, from: Int, length: Int, color: UIColor) {
        let att = NSMutableAttributedString(string: text);
        att.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSRange(location: from, length: length))
        self.setAttributedTitle(att, for: .normal)
    }
    
    ///This Function will underline the current text of the button for specified range
    /// - if range is nil then whole text will be underlined
    /// - Color will be as tint color
    /// - parameter Range: Range of text you want underline only
    func UnderLineButton(Range: NSRange?) {
        
        let Text = self.titleLabel?.text ?? ""
        
        let attributedText = NSMutableAttributedString(string: Text)
        
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: Range ??  NSRange(location: 0, length: Text.count))
        
        attributedText.addAttributes([NSAttributedString.Key.foregroundColor: self.tintColor ?? UIColor.black], range: Range ??  NSRange(location: 0, length: Text.count))
        
        self.setAttributedTitle(attributedText, for: .normal)
    }
}
extension UILabel{
    
    ///This function will add inter line spacing to your lable with the help of NSMutableAttributedString
    /// - note: Make sure numberOfLines is set to 0 or > 1 for line spacing.
    /// - String must be > 0 to get this running
    /// - parameter spacingValue: Space between lines you wanted if not nil
    /// - parameter CharacterSpacing:  will add space between characters if not nil
    func addSpacing(LineHeight: CGFloat?, CharacterSpacing: Double?, range: NSRange?) ->  CGFloat{
        guard let textString = text else { return 0 }
        
        guard (textString.count > 0) else { return 0}
        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = self.textAlignment
        
        var space = LineHeight ?? 0 - self.font.pointSize - (self.font.lineHeight - self.font.pointSize)
        
        if let LSpace = LineHeight{
            
            space = LSpace - self.font.pointSize - (self.font.lineHeight - self.font.pointSize)
            
            paragraphStyle.lineSpacing = space
            
            attributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: range ?? NSRange(location: 0, length: attributedString.length
                                       ))
        }
        
        if let CSpace = CharacterSpacing{
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CSpace, range: range ?? NSRange(location: 0, length: attributedString.length - 1))
        }
        
        self.text = ""
        self.attributedText = attributedString
        
        return space
    }
    
    ///This function will add inter line spacing to your lable with the help of NSMutableAttributedString
    /// - note: Make sure numberOfLines is set to 0 or > 1 for line spacing.
    /// - String must be > 0 to get this running
    /// - parameter spacingValue: Space between lines you wanted if not nil
    /// - parameter CharacterSpacing:  will add space between characters if not nil
    func addSpacing(spacingValue: CGFloat?, CharacterSpacing: Double?, range: NSRange?) {
        guard let textString = text else { return }
        
        guard (textString.count > 0) else { return }
        let attributedString = NSMutableAttributedString(string: textString)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = self.textAlignment
        
        if let LSpace = spacingValue{
            paragraphStyle.lineSpacing = LSpace
            
            attributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: range ?? NSRange(location: 0, length: attributedString.length
                                       ))
        }
        
        if let CSpace = CharacterSpacing{
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CSpace, range: range ?? NSRange(location: 0, length: attributedString.length - 1))
        }
        attributedText = attributedString
    }
    
    /// This function will underline your lable text
    /// - parameter Color: Color of the text default is textColor or Black
    /// - parameter range:  The range of text you wanted with underline default is all
    func GiveMeUnderline(Color: UIColor?, range: NSRange?) {
        
        if let text = self.text{
            
            let attributedText = NSMutableAttributedString(string: text)
            
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range ?? NSRange(location: 0, length: text.count))
            
            
            attributedText.addAttributes([NSAttributedString.Key.foregroundColor: Color ?? self.textColor ?? UIColor.black], range: range ?? NSRange(location: 0, length: text.count))
            
            self.attributedText = attributedText
        }
    }
}
extension UIImage{
    
    enum ContentMode {
        case contentFill
        case contentAspectFill
        case contentAspectFit
    }
    
    /// This Function will returns the resized image with prescribed contentMode
    /// - parameter withSize: Size of image
    /// - parameter contentMode: Mode of image inside frame
    func resize(withSize size: CGSize, contentMode: ContentMode = .contentAspectFill) -> UIImage? {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        switch contentMode {
        case .contentFill:
            return resize(withSize: size)
        case .contentAspectFit:
            let aspectRatio = min(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        case .contentAspectFill:
            let aspectRatio = max(aspectWidth, aspectHeight)
            return resize(withSize: CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio))
        }
    }
    private func resize(withSize size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// This function will create a selection indicator for UITabbarConrollers
    /// - parameter color: Color of indicator
    /// - parameter size: size of indicator
    /// - parameter lineWidth: width of indicator
    /// - returns: UIImage with sepcified attributes
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        
        var x: CGFloat = 20
        var y: CGFloat = 0
        
        if UIViewController().isNotched() {
            x = size.width/4
            y = size.height - (lineHeight * 6)
        } else {
            x = size.width/4
            y = size.height - lineHeight
        }
        UIRectFill(CGRect(origin: CGPoint(x: x,y :y), size: CGSize(width: size.width/2, height: 2)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    /// Returns the data for the specified image in JPEG format.
    /// - If the image objectâ€™s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - parameter jpegQuality: quality you wanted of the image data to be
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    /// Compresses the UIImage to the certain quality
    /// - this function will compromise the qulity and size of image
    /// - parameter CompressionMode: thq quality compressions mode you want for the image
    /// - returns: Compressed images based on specfied mode
    func Compress(CompressionMode: JPEGQuality) -> UIImage{
        let CompressedImage = self.jpegData(compressionQuality: CompressionMode.rawValue)!
        
        return UIImage(data: CompressedImage)!
    }
    
    /// This function will initalize the new uiimage with the sepcified size and color
    /// - parameter color: Color of the UIImage You wanted
    /// - parameter size: Size of the image you wanted
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// this function will convert the gradient layer into UIImage
    /// - image size will be the same as gradient layer size
    /// - parameter gradientLayer: CAGradientLayer you wanted to convert to
    /// - returns: UIImage from the gradientLayer
    func getImageFrom(gradientLayer:CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
    
    /// This function will create the image from layer of the layer Size
    /// - parameter layer: CALayer you wanted to turn into an Image
    /// - returns: Optional UIImage
    static func imageFromLayer (layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContext(layer.frame.size)
        guard let currentContext = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in: currentContext)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
    
}
extension UITextField{
    
    func customAccesoryView(BarTint: UIColor, OkAction: Selector?, CancelAction: Selector?, target: Any?) {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: target, action:OkAction)
        doneButton.tintColor = UIColor.white
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: target, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: target, action: CancelAction)
        cancelButton.tintColor = UIColor.white
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        toolbar.barTintColor = BarTint
        self.inputAccessoryView = toolbar
    }
    
    /// This function will append the text for UITextField
    /// - parameter Spacing: Size spacing you want
    func appendText(Spacing: CGFloat, Direction: Location) {
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: Spacing, height: self.frame.height))
        if Direction == .left{
            leftView = iconContainerView
            leftViewMode = .always
        } else {
            rightView = iconContainerView
            rightViewMode = .always
        }
    }
    
    /// This function will set an icon to the specfied position for both boxed and round edges TextField
    /// -  if isRounded is true the the textfield will be autometically gets rounded
    /// - you can always override the corner radius property
    /// - make sure your icon or image is propery with edge insets
    /// - parameter Postion: Position of the icon in textfield
    /// - parameter Image: Icon asset you want to set
    /// - parameter isRounded: if textfield is rounded or not
    func setIcon(Postion: Location, Image: UIImage, isRounded: Bool, ImageSize: CGSize?, TintColor: UIColor?, Padding: CGFloat?) {
        
        var x: CGFloat = Padding ?? 5
        var y: CGFloat = 0
        var width: CGFloat = 40
        
        if isRounded{
            
            self.RoundMe(Radius: nil)
            
            if Postion == .left{
                x = Padding ?? 20
            } else {
                x = Padding ?? 10
            }
            width = width + 20
        } else {
            x = Padding ?? 5
        }
        
        var imgFrame: CGRect {
            if let ImgSize = ImageSize{
                let y = (self.frame.height - ImgSize.width) / 2
                return CGRect(x: x, y: y, width: ImgSize.width, height: ImgSize.height)
            } else {
                return CGRect(x: x, y: 0, width: 30, height: self.frame.height)
            }
        }
        
        
        let iconView = UIImageView(frame: .zero)
        
        if let color = TintColor{
            iconView.image = Image.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = color
        } else {
            iconView.image = Image.withRenderingMode(.alwaysOriginal)
        }
        
        iconView.contentMode = .scaleAspectFit
        
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        
        iconContainerView.addSubview(iconView)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor, constant: 0),
            iconView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor, constant: Padding ?? x),
            iconView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: -(Padding ?? x)),
            iconView.widthAnchor.constraint(equalToConstant: ImageSize?.width ?? 30),
            iconView.heightAnchor.constraint(equalToConstant: ImageSize?.height ?? self.frame.height)
        ])
        
        if Postion == .left{
            leftView = iconContainerView
            leftViewMode = .always
        } else {
            rightView = iconContainerView
            rightViewMode =  .always
        }
    }
    
    /// This function will set an button icon to the specfied position for both boxed and round edges TextField
    /// -  if isRounded is true the the textfield will be autometically gets rounded
    /// - you can always override the corner radius property
    /// - parameter Postion: Position of the icon in textfield
    /// - parameter Image: Icon asset you want to set
    /// - parameter isRounded: if textfield is rounded or not
    /// - parameter Action: Action selector you wanted to perform
    /// - parameter target: Target for UIButton, mostly self or nil.
    func SetButton(Postion: Location, Image: UIImage, isRounded: Bool, Action: Selector, target: Any?) -> UIButton{
        
        var x: CGFloat = 5
        var width: CGFloat = 40
        
        if isRounded{
            
            self.RoundMe(Radius: nil)
            
            if Postion == .left{
                x = 20
            } else {
                x = 10
            }
            width = width + 20
        } else {
            x = 5
        }
        
        let Button = UIButton(frame:
                                CGRect(x: x, y: 0, width: 30, height: self.frame.height))
        
        Button.setImage(Image, for: .normal)
        
        Button.imageView?.contentMode = .scaleAspectFit
        
        Button.addTarget(target, action: Action, for: .touchUpInside)
        
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        
        iconContainerView.addSubview(Button)
        
        if Postion == .left{
            leftView = iconContainerView
            leftViewMode = .always
        } else {
            rightView = iconContainerView
            rightViewMode =  .always
        }
        
        return Button
        
    }
    
    /// This function will block the white space inputs of the text while editing
    /// - editingChanged targeted for this method if in case you decide to override this won't work or yours won't work.
    func DisableWhiteSpaceInput() {
        self.addTarget(self, action: #selector(TextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func TextFieldDidChange(_ textField: UITextField) {
        if textField.text?.containsWhitespace == true{
            textField.deleteBackward()
        }
    }
    
    /// This function will change color of your placeholder
    /// - this function will return NSMutableAttributedString if you wanted to add ant other attributes
    /// - parameter color: Color you wanted for the placeholder
    /// - returns: NSMutableAttributedString
    func ColorMyPlaceHolder(color: UIColor) -> NSMutableAttributedString{
        var myMutableStringTitle = NSMutableAttributedString()
        
        if let text = self.placeholder{
            myMutableStringTitle = NSMutableAttributedString(string: text)
            
            myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range:NSRange(location:0,length:text.count))
            
            self.attributedPlaceholder = myMutableStringTitle
            
        }
        return myMutableStringTitle
    }
    
    func customizePlaceHolder(color: UIColor, font: UIFont) {
        var myMutableStringTitle = NSMutableAttributedString()
        
        if let text = self.placeholder{
            myMutableStringTitle = NSMutableAttributedString(string: text)
            
            myMutableStringTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range:NSRange(location:0,length:text.count))
            
            myMutableStringTitle.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location:0,length:text.count))
            
            self.attributedPlaceholder = myMutableStringTitle
            
        }
    }
    
}
extension UIDevice {
    static let MymodelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
            
        }
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
#if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "0"
            case "iPod7,1":                                 return "0"
            case "iPod9,1":                                 return "0"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "0"
            case "iPhone4,1":                               return "0"
            case "iPhone5,1", "iPhone5,2":                  return "0"
            case "iPhone5,3", "iPhone5,4":                  return "0"
            case "iPhone6,1", "iPhone6,2":                  return "0"
            case "iPhone7,2":                               return "0"
            case "iPhone7,1":                               return "0"
            case "iPhone8,1":                               return "0"
            case "iPhone8,2":                               return "0"
            case "iPhone9,1", "iPhone9,3":                  return "0"
            case "iPhone9,2", "iPhone9,4":                  return "0"
            case "iPhone8,4":                               return "0"
            case "iPhone10,1", "iPhone10,4":                return "0"
            case "iPhone10,2", "iPhone10,5":                return "0"
            case "iPhone10,3", "iPhone10,6":                return "40"
            case "iPhone11,2":                              return "40"
            case "iPhone11,4", "iPhone11,6":                return "40"
            case "iPhone11,8":                              return "40"
            case "iPhone12,1":                              return "40"
            case "iPhone12,3":                              return "40"
            case "iPhone12,5":                              return "40"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "\(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
#elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "\(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
#endif
        }
        return mapToDevice(identifier: identifier)
    }()
}
extension UIViewController{
    
    func Share(file Location: URL) {
        
        let fileURL = Location
        
        // Create the Array which includes the files you want to share
        var filesToShare = [Any]()
        
        // Add the path of the file to the Array
        filesToShare.append(fileURL)
        
        // Make the activityViewContoller which shows the share-view
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        
        // Show the share-view
        if #available(iOS 13.0, *) {
            activityViewController.isModalInPresentation = true
        }
        
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    ///This function will setup a navbar item with action, title, icon whatever you like everything is optional.
    /// - if tint color is nil and icon is not nil then icon will be shown as its original colors
    /// - you can pass any size of icon it will be autometically rezied to 20X20
    /// - Target can be set as nil or self make sure you just don't crash the app
    /// - parameter Position: Position of item you wanted left or right
    /// - parameter Title: if no icon and just text hop in
    /// - parameter Icon: UIImage for the item
    /// - parameter TintColor: tintcolor of theitem
    /// - parameter Action: action you would like to perform on click
    /// - parameter Target: target can be self or nil
    /// - parameter ItemSize: size of the item default is 22X22
    func SetNavBarItem(Position: Location, Title: String?,Icon: UIImage?, TintColor: UIColor?, Action: Selector?, Target: Any?, ItemSize: CGSize?) {
        
        let image = Icon?.resize(withSize: ItemSize ?? CGSize(width: 22, height: 22), contentMode: .contentAspectFit)
        var button1: UIBarButtonItem!
        
        if TintColor == nil{
            
            button1 = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain, target: Target, action:Action)
        } else {
            button1 = UIBarButtonItem(image: image, style: .plain, target: Target, action:Action)
            button1.tintColor = TintColor
        }
        
        button1.title = Title
        
        switch Position {
        case .left:
            self.navigationItem.leftBarButtonItem  = button1
        case .right:
            self.navigationItem.rightBarButtonItem  = button1
        }
        
    }
    
    /// This function will dimiss or pop the current view controller
    @IBAction func GoBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    /// Returns a bool if device hase rounded edges or not
    /// - Devices UpTo ios13
    func isNotched() -> Bool {
        if UIDevice.MymodelName == "40"{
            return true
        } else {
            return false
        }
    }
    
    ///Will return the height of the bottom baar
    var BottomBarHeight: CGFloat {
        
        return self.tabBarController?.tabBar.frame.height ?? 0
    }
    
    /// will return the height of the navigation bar including status bar
    var navigationBarHeight: CGFloat {
        
        return UIApplication.shared.statusBarFrame.size.height +
        (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    /// This will show an alert and start editing the provided textField as soon as user clicks on OK
    /// - parameter Message: Message You want to show to the user
    /// - parameter textField: textField you wants to make the first responsder
    func ShowTextFieldAlert(Message: String, textField: UITextField) {
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ALERT) in
            textField.becomeFirstResponder()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// This will show an alert and start editing the provided textView as soon as user clicks on OK
    /// - parameter Message: Message You want to show to the user
    /// - parameter textView: textView you wants to make the first responsder
    func ShowTextViewAlert(Message: String, textView: UITextView) {
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ALERT) in
            textView.becomeFirstResponder()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showICloudPopup() {
        let alertController = UIAlertController(title: "iCloud Disabled",
                                                message: "Please, go to settings and sign in with your iCloud account",
                                                preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.settings, comment: ""))", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        let cancelAction = UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""))", style: .cancel)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    /// This will show an simple alert with a message
    /// - parameter Message: Message You want to show to the user
    func showSimpleAlert(Message: String) {
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ok, comment: ""))", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// This will show an simple alert with a message and pop or dismiss the current ViewController
    /// - parameter Message: Message You want to show to the user
    func ShowAlertAndGoBack(Message: String) {
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ALERT) in
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// This will show an simple alert with a message and push the view controller
    /// - parameter SBName: Storyboard bame of the view controller
    /// - parameter id: id of the view controller you wanted to push
    /// - parameter Message: Message You want to show to the user
    /// - parameter Style: Style you wants either present or push the View Controller
    func ShowAlertAndGoTo(SBName: String,id: String, Message: String, Style: ShowStyle) {
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ok, comment: ""))", style: .default, handler: { (ALERT) in
            
            let storyboard = UIStoryboard(name: SBName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: id)
            
            switch Style{
            case .Push:
                self.navigationController?.pushViewController(vc, animated: true)
            case .Present:
                self.present(vc, animated: true, completion: nil)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// This will show an simple alert with a message and push the view controller
    /// - parameter SBName: Storyboard bame of the view controller
    /// - parameter id: id of the view controller you wanted to push
    /// - parameter Message: Message You want to show to the user
    /// - parameter Style: Style you wants either present or push the View Controller
    func ShowAlertAndGoTo(SBName: String,id: String, Message: String, Style: ShowStyle, ActionTitle: String) {
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: ActionTitle, style: .default, handler: { (ALERT) in
            
            let storyboard = UIStoryboard(name: SBName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: id)
            
            switch Style{
            case .Push:
                self.navigationController?.pushViewController(vc, animated: true)
            case .Present:
                self.present(vc, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""))", style: .cancel, handler: { (ALERT) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// This function will show an alert and perform action after user clicks on button
    /// - action nil will only display alert with message use SimpleAlert functiion for that.
    /// - parameter Message: Message you wanted to display
    /// - parameter action: Action will
    func showAlertAndPerform(Message: String, action: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.ok, comment: ""))", style: .default, handler: action))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /// This function will show an alert and perform action after user clicks on button
    /// - action nil will only display alert with message use SimpleAlert functiion for that.
    /// - parameter Title: Title you wanted to display
    /// - parameter Placeholder: placeholder you want to display
    /// - parameter action: Action will
    func showTextFieldAlertAndPerform(Title: String, Placeholder: String, action: ((String) -> Void)? = nil) {
        // Create an instance of UIAlertController
        let alert = UIAlertController(title: Title, message: nil, preferredStyle: .alert)
        
        // Add a text field to the alert controller
        alert.addTextField { textField in
            textField.placeholder = Placeholder
            textField.keyboardType = .decimalPad
        }
        
        let cancelAction = UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.cancel, comment: ""))", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.confirm, comment: ""))", style: .default) { _ in
            if let textField = alert.textFields?.first,
               let enteredText = textField.text {
                action?(enteredText)
                print("Entered text: \(enteredText)")
            }
        }
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /// This function will show an alert and perform action after user clicks on Retry button.
    /// - action nil will only display alert with message use SimpleAlert functiion for that.
    /// - parameter Message: Message you wanted to display
    /// - parameter Retryaction: Action for retry click
    /// - parameter CancelAction: Action for Cancel click
    func showRetryAlertAndPerform(Message: String, Retryaction: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: Message, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: Retryaction))
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    /// This Function will autometically manages the respondings of textFields
    /// - Important : Make sure you follow all the below protocols to execute the function
    /// - make sure you have set delegates in all textFields
    /// - make sure you confroms to the UITextFieldDelegate
    /// - make sure you are executing this function inside textFieldShouldReturn(_:)
    /// - The sequence will be followed as provided in the array of textField parameter
    /// - parameter textFields: Array of textFields you wanted to enable the the function
    func autoReturnResponder(textFields: [UITextField], completion: @escaping (() -> Void)) {
        for i in 0..<textFields.count{
            
            if textFields[i].isFirstResponder && i < textFields.count - 1{
                textFields[i + 1].becomeFirstResponder()
                break
            } else if textFields[i].isFirstResponder && i == textFields.count - 1{
                textFields[i].resignFirstResponder()
                completion()
                break
            }
        }
    }
    
    ///This Function vill add gradient layer at ) index of the UIView
    /// - colors will be in sequence provided index vise
    /// - parameter Direction: Direction will define the direction of gradient flow
    /// - parameter Colors: Array of CGColors You wanted to make garient of
    /// - parameter Frame: Frame of the gradient layer you want
    /// - returns: CAGradientLayer
    func MakeGradientLayer(Direction: GradientDirection, Colors: [CGColor], Frame: CGRect) -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = Colors
        
        if Direction == .Horizontal{
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        }
        gradientLayer.frame = Frame
        
        return gradientLayer
    }
    
    /// This fucntion will add tap gesture in your view whic will hide keyboard on screen tap
    func HideKeyboardOnTouches() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
    }
    
    /// Hides Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    enum VibrationType{
        case low,medium,high
    }
    
    /**
     This function will vibrate the phone to alert the user.
     - parameters:
     - Hardness: Hardness of the vibration you need.
     */
    func VibratePhone(Hardness: VibrationType) {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        switch Hardness {
        case .low:
            notificationFeedbackGenerator.notificationOccurred(.success)
        case .medium:
            notificationFeedbackGenerator.notificationOccurred(.warning)
        case .high:
            notificationFeedbackGenerator.notificationOccurred(.error)
        }
    }
}
extension UITabBarController{
    /// This Function is for long tap gesture which will convert the X location
    /// - returns: Integer indication the selected Index
    /// - parameter GestureLocationX: X postion of the touch
    /// - parameter width: width of your tab bar
    /// - note: How can you get X:
    /// - let translation = sender.location(in: sender.view):
    /// - let touchLoction = translation.x
    func selectedIndexForTabbar(GestureLocationX: CGFloat, width: CGFloat) -> Int{
        
        let div1 = 0..<width/5
        let div2 = div1.upperBound...(div1.upperBound * 2)
        let div3 = div2.upperBound...(div1.upperBound * 3)
        let div4 = div3.upperBound...(div1.upperBound * 4)
        
        if div1.contains(GestureLocationX) {
            return 1
        } else if div2.contains(GestureLocationX) {
            return 2
        } else if div3.contains(GestureLocationX) {
            return 3
        } else if div4.contains(GestureLocationX) {
            return 4
        } else {
            return 5
        }
        
    }
}
extension Int{
    /// returns the string by converting mins into past
    func ConvertMin() -> String{
        let min = self
        
        if min > 60{
            let hour = min / 60
            
            if hour > 24 {
                let day = hour / 24
                return "\(String(day)) day"
            } else {
                return "\(String(hour)) hour"
            }
        } else {
            return "\(String(min)) min"
        }
    }
    
    /// Will short the integer into string like K,M
    /// - will transform the long int to human readable string
    /// - 1000 = 1K
    /// - 1000000 = 1M
    /// - returns: sorted string
    func sortedString() -> String {
        if self >= 1000 && self < 10000 {
            return String(format: "%.1fK", Double(self/100)/10).replacingOccurrences(of: ".0", with: "")
        }
        if self >= 10000 && self < 1000000 {
            return "\(self/1000)k"
        }
        if self >= 1000000 && self < 10000000 {
            return String(format: "%.1fM", Double(self/100000)/10).replacingOccurrences(of: ".0", with: "")
        }
        if self >= 10000000 && self < 1000000000{
            return "\(self/1000000)M"
        }
        if self >= 1000000000 {
            return "\(self/1000000000)B"
        }
        
        return String(self)
    }
    
}
extension UINavigationController {
    
    /// Go Back to the perticular one of the view parent controllers of current view controller
    /// - parameter vc: Provide a UIIViewController where you'd like to go back to
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
    
    /// This function will make your navigation bar transperent
    /// - set navigationBar.isTranslucent to false far restore it
    func TransperantNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
    
    ///replace your top view controller with the specific view controller
    /// - parameter viewController: view controller to replace
    /// - parameter animated: animate the change or not
    func replaceTopViewController(with viewController: UIViewController, animated: Bool) {
        var vcs = viewControllers
        vcs[vcs.count - 1] = viewController
        setViewControllers(vcs, animated: animated)
    }
}
extension WKWebView {
    /// This  function will autometically creates the the url requests and will load the url inside the WebView
    /// - parameter urlString: URL in string you wanted to load
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
extension UITableViewCell{
    
    enum DGCellAnimationType{
        case LargeScale, LowScale, MedScale, CrossDissolve, Bounce, SlideIn
    }
    
    /// This Function will animate the cells of the UITableView
    /// - the effect of this is depend where you call it
    /// -  you can call this method in both cellForRowAt(_ :) or tableView(_:willDisplay:forRowAt:)
    /// - you can handle the time you wanted the program run with the help of completionHandler
    /// - parameter AnimationType: The type of animation you like for the cell
    /// - parameter withOpacity: Opacity will also animate the alpha of the cell which will gives an extra ordinary animation to smoothen the animation
    /// - parameter indexPath: some animations are based on the indexPath which will animate them one after another
    /// - parameter completionHandler: Completion handler will allow you to do some task after the animations are over. default is nil.
    func AnimateCell(AnimationType: DGCellAnimationType, withOpacity: Bool, indexPath: IndexPath, completionHandler: ((Bool) -> Void)? = nil) {
        
        if withOpacity{
            self.alpha = 0
        }
        
        switch AnimationType {
        case .LargeScale:
            self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
            UIView.animate(withDuration: 0.3, animations: {
                self.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
                self.alpha = 1
            },completion: { finished in
                UIView.animate(withDuration: 0.1, animations: {
                    self.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: completionHandler)
            })
        case .LowScale:
            
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = CGAffineTransform.identity
                self.alpha = 1
            }, completion: completionHandler)
            
        case .MedScale:
            
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = CGAffineTransform.identity
                self.alpha = 1
            }, completion: completionHandler)
            
        case .CrossDissolve:
            
            UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), options: .curveEaseInOut, animations: {
                self.alpha = 1
            }, completion: completionHandler)
        case .Bounce:
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            UIView.animate(
                withDuration: 0.3,
                delay: 0.05 * Double(indexPath.row),
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.1,
                options: [.curveEaseInOut],
                animations: {
                    self.alpha = 1
                    self.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: completionHandler)
            
        case .SlideIn:
            self.transform = CGAffineTransform(translationX: self.superview?.bounds.width ?? UIScreen.main.bounds.width, y: 0)
            UIView.animate(
                withDuration: 0.3,
                delay: 0.05 * Double(indexPath.row),
                options: [.curveEaseInOut],
                animations: {
                    self.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: completionHandler)
        }
    }
}
extension UIScrollView {
    //This function will scroll the table view to the very bottom of scrollView
    /// - parameter animated: if you want the scroll animated or not
    func scrollsToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    func scrollsToTop(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: 0)
        setContentOffset(bottomOffset, animated: animated)
    }
}
extension UITableView {
    ///This function will reload data and will shows the animations as cross dissolve
    func AnimatedReloadData() {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {self.reloadData()}, completion: nil)
    }
    
    ///This function will scroll the table view to the very bottom of tableView
    /// - parameter animated: if you want the scroll animated or not
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    ///This function will scroll the table view to the very top of tableView
    /// - parameter animated: if you want the scroll animated or not
    func scrollToTop(animated: Bool) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: animated)
        }
    }
    
    /// This function will set an empty message for your collection in very center of the view
    /// - note: use restore() function to remove the message
    /// - parameter message: Message you wanted to show
    /// - parameter font: font of the text
    /// - parameter textColor: color of text
    func setEmptyMessage(_ message: String, font: UIFont?, textColor: UIColor?) {
        let messageLabel = UILabel()
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundView = messageLabel;
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            messageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20),
        ])
        
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = font ?? UIFont.systemFont(ofSize: 23)
        messageLabel.textColor = textColor ?? UIColor.gray
        messageLabel.sizeToFit()
    }
    /// restore empty message
    func restore() {
        self.backgroundView = nil
    }
}
extension UICollectionView {
    ///This function will reload data and will shows the animations as cross dissolve
    func AnimatedReloadData() {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {self.reloadData()}, completion: nil)
    }
    
    /// This function will set an empty message for your collection in very center of the view
    /// - note: use restore() function to remove the message
    /// - parameter message: Message you wanted to show
    /// - parameter font: font of the text
    /// - parameter textColor: color of text
    func setEmptyMessage(_ message: String,  font: UIFont?, textColor: UIColor?) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        
        messageLabel.font = font ?? UIFont.systemFont(ofSize: 25)
        messageLabel.textColor = textColor ?? UIColor.lightGray
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    func restore() {
        self.backgroundView = nil
    }
}
extension UISearchBar {
    ///Enables the Cancle button of search bar when you call
    /// - call when user begin the search
    func enableCancelButton(in view: UIView) {
        view.subviews.forEach {
            enableCancelButton(in: $0)
        }
        if let cancelButton = view as? UIButton {
            cancelButton.isEnabled = true
            cancelButton.isUserInteractionEnabled = true
        }
    }
}
extension NSMutableAttributedString{
    /// This function will helps you to append another attributed string after on another
    /// -  parameter attributedString: the string which will append the current one
    func append(attributedString:NSMutableAttributedString) -> NSMutableAttributedString{
        let newAttributedString = NSMutableAttributedString()
        newAttributedString.append(self)
        newAttributedString.append(attributedString)
        return newAttributedString
    }
    
    /// Color the perticular text using serach text method
    /// - parameter textToFind: Text To Color
    /// - parameter color: Color You want to Colorizw
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}
extension CGFloat{
    /// Will return the Current iOS version of the device in CGFload
    func iOSVersion() -> CGFloat{
        
        let f = (UIDevice.current.systemVersion as NSString).floatValue
        
        
        return CGFloat(f)
    }
}
extension UIRefreshControl {
    /// It will manually pull the refresh control in scrollview to show to the user
    func beginRefreshingManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: true)
        }
        beginRefreshing()
    }
}
extension Data {
    /// This function will return the hex String of the data
    /// - useful for token conversions
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
    var hexEncoded: String {
        return "0x" + self.hexString
    }
}
extension NSAttributedString {
    /// Give color to a perticular substring in string
    /// - parameter substring: Substring you wanted to get colored
    /// - parameter color: color of the highlited string
    func highlighting(_ substring: String, using color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: self)
        attributedString.addAttribute(.foregroundColor, value: color, range: (self.string as NSString).range(of: substring))
        return attributedString
    }
}
extension UIPickerView {
    /// This function will set an empty message for your collection in very center of the view
    /// - note: use restore() function to remove the message
    /// - parameter message: Message you wanted to show
    /// - parameter font: font of the text
    /// - parameter textColor: color of text
    func setEmptyMessage(message: String, font: UIFont?, textColor: UIColor?) {
        let messageLabel = UILabel(frame:.zero)
        messageLabel.text = message
        messageLabel.textColor = textColor ?? UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        
        messageLabel.font = font ?? UIFont.systemFont(ofSize: 23)
        messageLabel.textColor = textColor ?? UIColor.black
        messageLabel.sizeToFit()
        
        self.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            messageLabel.topAnchor.constraint(equalTo: self.topAnchor)])
    }
    
    /// will remove message view from the UIPickerView
    func restore() {
        
        for i in self.subviews{
            i.removeFromSuperview()
        }
        
    }
}
extension Date{
    func toString(format: String) -> String{
        let df = DateFormatter()
        df.dateFormat = format
        df.locale = Locale(identifier: "en_US_POSIX")
        return df.string(from: self)
    }
}
extension UIColor {
    // Check if the color is light or dark, as defined by the injected lightness threshold.
    // Some people report that 0.7 is best. I suggest to find out for yourself.
    // A nil value is returned if the lightness couldn't be determined.
    func isLight(threshold: Float = 0.5) -> Bool? {
        let originalCGColor = self.cgColor
        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}
extension UIColor {
    
    func Hex(hexString: String, alpha:CGFloat = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    fileprivate func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
extension UIRefreshControl{
    func endRefreshingAndSet(title: NSAttributedString) {
        self.endRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.attributedTitle = title
        }
    }
    
    func Setup(view: UIView, Title: String?, action: Selector, target: Any?,TintColor: UIColor?) {
        
        if let TableView = view as? UITableView {
            TableView.refreshControl = self
        } else if let ScrollView = view as? UIScrollView {
            ScrollView.refreshControl = self
        } else if let CollectionView = view as? UICollectionView {
            CollectionView.refreshControl = self
        }
        
        if let text = Title{
            self.attributedTitle = NSAttributedString(string: text)
        }
        
        if let color = TintColor{
            self.tintColor = color
        }
        
        self.layer.zPosition = -1
        
        self.addTarget(target, action: action, for: .valueChanged)
        
        self.beginRefreshing()
    }
}
extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}
extension UILabel{
    
    @IBInspectable
    var hexTextColor: String {
        set{
            self.textColor = UIColor().Hex(hexString: newValue)
        }
        get{
            return self.hexTextColor
        }
        
    }
    
    ///This function will add inter line spacing to your lable with the help of NSMutableAttributedString
    /// - note: Make sure numberOfLines is set to 0 or > 1 for line spacing.
    /// - String must be > 0 to get this running
    /// - parameter spacingValue: Space between lines you wanted if not nil
    /// - parameter CharacterSpacing:  will add space between characters if not nil
    func addSpacing(spacingValue: CGFloat?, CharacterSpacing: Double?, range: NSRange?, paragraphSpacing: CGFloat?) {
        
        guard let textString = text else { return }
        
        guard (textString.count > 0) else { return }
        
        let attributedString = NSMutableAttributedString(string: textString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        if let paragraphSpacing = paragraphSpacing {
            paragraphStyle.paragraphSpacing = paragraphSpacing
        }
        
        if let LSpace = spacingValue{
            paragraphStyle.lineSpacing = LSpace
            
            attributedString.addAttribute(
                .paragraphStyle,
                value: paragraphStyle,
                range: range ?? NSRange(location: 0, length: attributedString.length
                                       ))
        }
        
        if let CSpace = CharacterSpacing{
            attributedString.addAttribute(NSAttributedString.Key.kern, value: CSpace, range: range ?? NSRange(location: 0, length: attributedString.length - 1))
        }
        
        attributedText = attributedString
    }
    
}
extension UIView {
    
    @IBInspectable
    var HexBackgroundColor: String {
        set{
            self.backgroundColor = UIColor().Hex(hexString: newValue)
        }
        get{
            return self.HexBackgroundColor
        }
        
    }
    
}
extension UIView {
    func addDashedBorder(color: UIColor, radius: CGFloat?) {
        let color = color.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: radius ?? self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
}
extension UIView {
    var isSelectedView: Bool{
        get{
            return self.isSelectedView
        }
        set{
            self.isSelectedView = newValue
        }
    }
}
extension UINavigationController {
    var previousViewController: UIViewController? {
        viewControllers.count > 1 ? viewControllers[viewControllers.count - 2]: nil
    }
}
extension UIImageView {
    @IBInspectable
    var changeRenderingModeToTemplate: Bool{
        get{
            return self.changeRenderingModeToTemplate
        }
        
        set{
            if newValue == true{
                self.image = self.image?.withRenderingMode(.alwaysTemplate)
            } else {
                self.image = self.image?.withRenderingMode(.automatic)
            }
        }
    }
}
extension UIViewController{
    func setTabBarHidden(hidden: Bool, animated: Bool) {
        // hide tab bar
        let frame = self.tabBarController?.tabBar.frame
        let height = frame?.size.height
        var offsetY = (!hidden ? -height!: height)
        print ("offsetY = \(offsetY)")
        // zero duration means no animation
        let duration:TimeInterval = (animated ? 0.3: 0.0)
        // animate tabBar
        if frame != nil {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame!.offsetBy(dx: 0, dy: offsetY!)
                self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY!)
                self.view.setNeedsDisplay()
                self.view.layoutIfNeeded()
                return
            }
        }
    }
    
    func isTabBarIsHidden() -> Bool {
        return !((self.tabBarController?.tabBar.frame.origin.y)! < UIScreen.main.bounds.height)
    }
}
func Color(_ red: CGFloat,_ green: CGFloat,_ blue: CGFloat,_ alpha: CGFloat) -> UIColor{
    
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    
}
func Color(Hex: String) -> UIColor{
    
    return UIColor.init().Hex(hexString: Hex)
    
}
extension UIImageView {
    func ChangeImageWithAnimation(_ image: UIImage) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
            self.image = image
        } completion: { (_) in
            
        }
    }
}
extension UIView {
    var MyIndexPath: IndexPath{
        get{
            return self.MyIndexPath
        }
        
        set{
            self.MyIndexPath = newValue
        }
    }
}
import Foundation
import UIKit
///This constraint will autometically
class AutoAdjustableWidth: NSLayoutConstraint {
    
    var MainConstant: CGFloat = 0 // Main Constant to hold the default value
    
    ///Only enablig this will trigger the prorata
    @IBInspectable var EnableProrata: Bool = false{
        didSet{
            
            MainConstant = constant
            
            if EnableProrata == true{ // if prorata is enabled change the constant value
                
                self.constant = self.constant.proRataWidth()
                
            }
        }
    }
    
}
///This constraint will autometically
class AutoAdjustableConstraint: NSLayoutConstraint {
    
    var MainConstant: CGFloat = 0 // Main Constant to hold the default value
    
    ///Only enablig this will trigger the prorata
    @IBInspectable var EnableProrata: Bool = false{
        didSet{
            
            MainConstant = constant
            
            if EnableProrata == true{ // if prorata is enabled change the constant value
                
                self.constant = self.constant.proRata()
                
            }
        }
    }
    
}
extension CGFloat{
    
    ///Will return the prorata compliant float value based on given float if current val is > 0
    func proRata() -> CGFloat{
        
        if self > 0{
            return (self / 926) * UIScreen.main.bounds.height
        } else {
            return self
        }
        
        
    }
    
    ///Will return the prorata compliant float value based on given float if current val is > 0
    func proRataWidth() -> CGFloat{
        
        if self > 0{
            return (self / 428) * UIScreen.main.bounds.width
        } else {
            return self
        }
        
        
    }
    
}
class SelfSizedTableView: UITableView {
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

extension TimeInterval {
    func formatDate(_ format: String) -> String {
        
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
   
    }
}

extension TimeInterval {
    func getReadableDate() -> String? {
        let date = Date(timeIntervalSince1970: self)
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: LocalizationSystem.sharedInstance.getLanguage())

        if calendar.isDateInYesterday(date) {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.yesterday, comment: "")
        } else if calendar.isDateInToday(date) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        } else if calendar.isDate(date, equalTo: Date(), toGranularity: .weekOfYear) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date)
        } else {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
    }
}



// Generic function to convert Data to any Codable model
func convertDataToModel<T: Codable, U: Codable>(_ data: Data, primaryType: T.Type, fallbackType: U.Type) -> (primary: T?, fallback: U?) {
    let decoder = JSONDecoder()
    
    if let primaryModel = try? decoder.decode(primaryType, from: data) {
        return (primary: primaryModel, fallback: nil)
    } else if let fallbackModel = try? decoder.decode(fallbackType, from: data) {
        return (primary: nil, fallback: fallbackModel)
    } else {
        return (primary: nil, fallback: nil)
    }
}
