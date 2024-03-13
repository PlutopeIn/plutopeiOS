//
//  UIExtensions.swift
//  Plutope
//
//  Created by Priyanka Poojara on 02/06/23.
//
import UIKit

private var kAssociationKeyMaxLength: Int = 0
private var tapGestureCompletionKey: UInt8 = 0

@IBDesignable
class DesignableView: UIView {
}
@IBDesignable
class DesignableButton: UIButton {
}
@IBDesignable
class DesignableLabel: UILabel {
    /// for lable leading and tralling space
    var textEdgeInsets = UIEdgeInsets.zero {
           didSet { invalidateIntrinsicContentSize() }
       }
       
       open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
           let insetRect = bounds.inset(by: textEdgeInsets)
           let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
           let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
           return textRect.inset(by: invertedInsets)
       }
       
       override func drawText(in rect: CGRect) {
           super.drawText(in: rect.inset(by: textEdgeInsets))
       }
    @IBInspectable
       var paddingLeft: CGFloat {
           set { textEdgeInsets.left = newValue }
           get { return textEdgeInsets.left }
       }
       
       @IBInspectable
       var paddingRight: CGFloat {
           set { textEdgeInsets.right = newValue }
           get { return textEdgeInsets.right }
       }
}

@IBDesignable
class SpinnerView : UIView {

    override var layer: CAShapeLayer {
        get {
            return super.layer as! CAShapeLayer
        }
    }

    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.fillColor = nil
        layer.strokeColor = UIColor.init(named: "#E84118-1")?.withAlphaComponent(0.50).cgColor
        layer.lineWidth = 3
        setPath()
    }

    override func didMoveToWindow() {
        animate()
    }

    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }

    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
        init(_ secondsSincePriorPose: CFTimeInterval, _ start: CGFloat, _ length: CGFloat) {
            self.secondsSincePriorPose = secondsSincePriorPose
            self.start = start
            self.length = length
        }
    }

    class var poses: [Pose] {
        get {
            return [
                Pose(0.0, 0.000, 0.7),
                Pose(0.6, 0.500, 0.5),
                Pose(0.6, 1.000, 0.3),
                Pose(0.6, 1.500, 0.1),
                Pose(0.2, 1.875, 0.1),
                Pose(0.2, 2.250, 0.3),
                Pose(0.2, 2.625, 0.5),
                Pose(0.2, 3.000, 0.7),
            ]
            
        }
    }

    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let poses = type(of: self).poses
        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)

       // animateStrokeHueWithDuration(duration: totalSeconds * 5)
    }

    func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = .linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
    func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        let count = 36
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        for i in 0 ... count{
            animation.values?[i] = UIColor(named: "#E84118-1")?.cgColor ?? UIColor()
        }
        
        animation.duration = duration
        animation.calculationMode = .linear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
}

extension UIView {
    /// Individual corner radius
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    @IBInspectable
    var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var maskCorners: CACornerMask {
        get {
            return layer.maskedCorners
        }
        set {
            self.clipsToBounds = true
            self.layer.maskedCorners = newValue
        }
    }
    //[.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    //MARK: NibView for Transculated constraint
    func addNibView(nibView : UIView){
    
        self.addSubview(nibView)
        
        nibView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nibView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            nibView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            nibView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            nibView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
        
        nibView.layoutIfNeeded()
        
    }
    
    /// Will assign view
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            self.addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder!: "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    //The method is used to cancel the check when use Chinese Pinyin input method.
    //Becuase the alphabet also appears in the textfield when inputting, we should cancel the check.
    func isInputMethod() -> Bool {
        if let positionRange = self.markedTextRange {
            if let _ = self.position(from: positionRange.start, offset: 0) {
                return true
            }
        }
        return false
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        
        guard !self.isInputMethod(), let prospectiveText = self.text,
              prospectiveText.count > maxLength
        else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
    
    
}

// MARK: Lable line spacing
extension UILabel {
    
    @IBInspectable var lineHeight: CGFloat {
        get {
            guard let paragraphStyle = attributedText?.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSParagraphStyle else {
                return 0
            }
            return paragraphStyle.lineSpacing + font.lineHeight
        }
        set {
            let attributedString = NSMutableAttributedString(string: text ?? "")
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = self.textAlignment
            
            let space = newValue - font.pointSize - (font.lineHeight - font.pointSize)
            paragraphStyle.lineSpacing = space
            
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            
            attributedText = attributedString
        }
    }
    
}

// for status bar
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

//setImage Color
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    //    mutating func capitalizeFirstLetter() {
    //        self = self.capitalizingFirstLetter()
    //    }
    // MARK:- convert string imogi to UIImage
    
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func convertHtml(font: UIFont? = nil, Fontcolor: UIColor? = .white) -> NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        let options : [NSAttributedString.DocumentReadingOptionKey : Any] =
        [.documentType:NSAttributedString.DocumentType.html,.defaultAttributes: String.Encoding.utf8.rawValue]
        
        do {
            if let font = font {
                guard let attr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
                    throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
                }
                var attrs = attr.attributes(at: 0, effectiveRange: nil)
                attrs[NSAttributedString.Key.font] = font
                attrs[NSAttributedString.Key.foregroundColor] = Fontcolor
                attr.setAttributes(attrs, range: NSRange(location: 0, length: attr.length))
                
                return attr
            } else {
                return try NSAttributedString(data: data, options: options, documentAttributes: nil)
            }
            
        } catch {
            return NSAttributedString()
        }
    }
}

//setImage Color
@IBDesignable
extension UIImageView {
    
    
    @IBInspectable
    var imageTintColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                //     layer.shadowColor = color.cgColor
                let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.image = templateImage
                self.tintColor = color
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    
}

//To set customize UISlider height
class CustomSlider: UISlider {
    
    @IBInspectable var trackLineHeight: CGFloat = 0.0
    override func trackRect(forBounds bound: CGRect) -> CGRect {
        return CGRect(origin: bound.origin, size: CGSize(width: bound.width, height: trackLineHeight))
    }
}

//change contrain multiplier
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

/// Tap Gesture extension
extension UIView {
    func addTapGesture(target: Any, action: Selector) {
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }
    
    /// Tap gesture extension
    typealias TapGestureCompletion = () -> Void
    
    func addTapGesture(completion: @escaping TapGestureCompletion) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        
        // Store the completion closure as an associated object
        objc_setAssociatedObject(self, &tapGestureCompletionKey, completion, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        // Retrieve the completion closure from the associated object
        if let completion = objc_getAssociatedObject(self, &tapGestureCompletionKey) as? TapGestureCompletion {
            completion()
        }
    }
}


extension UIScrollView {
    func addRefreshControl(target: Any, action: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: action, for: .valueChanged)
        refreshControl.tintColor = .white
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            addSubview(refreshControl)
        }
    }
    
    func endRefreshing() {
        if #available(iOS 10.0, *) {
            refreshControl?.endRefreshing()
        }
    }
}

/// - Class to update contraint values according to the mobilke devices
/// - Will check that weather device is notched or not
/// - Then apply constant value to your view
class NotchedConstraintConstant: NSLayoutConstraint{
    
    var MainConstant: CGFloat = 0 // Main Constant to hold the default value
    
    @IBInspectable var NonNotchedConst: CGFloat = 0{
        didSet{
            if EnableDynamicHeight{
                setUpConstraint()
            }
        }
    }
    @IBInspectable var NotchedConst: CGFloat = 0{
        didSet{
            if EnableDynamicHeight{
                setUpConstraint()
            }
        }
    }
    ///Only enablig this will trigger the prorata
    fileprivate func setUpConstraint() {
        if UIDevice.current.hasNotch == false{ // if prorata is enabled change the constant value
            
            self.constant = NonNotchedConst
            
        } else {
            
            self.constant = NotchedConst
            
        }
    }
    
    @IBInspectable
    var EnableDynamicHeight: Bool = false{
        didSet{
            
            MainConstant = constant
            if EnableDynamicHeight{
                setUpConstraint()
            }
        }
        
    }
    
}
/// Will check that device is notched or not
extension UIDevice{
    var hasNotch: Bool
    {
        if #available(iOS 11.0, *)
        {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else
        {
            // Fallback on earlier versions
            return false
        }
    }
}

/// Switch extension to update its height and width
extension UISwitch {

    static let standardHeight: CGFloat = 31
    static let standardWidth: CGFloat = 51
    
    @IBInspectable var width: CGFloat {
        set {
            set(width: newValue, height: height)
        }
        get {
            frame.width
        }
    }
    
    @IBInspectable var height: CGFloat {
        set {
            set(width: width, height: newValue)
        }
        get {
            frame.height
        }
    }
    
    func set(width: CGFloat, height: CGFloat) {

        let heightRatio = height / UISwitch.standardHeight
        let widthRatio = width / UISwitch.standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}

extension UILabel {

    func blur(_ blurRadius: Double = 2.5) {
        let blurredImage = getBlurryImage(blurRadius)
        let blurredImageView = UIImageView(image: blurredImage)
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        blurredImageView.tag = 100
        blurredImageView.contentMode = .center
        blurredImageView.backgroundColor = UIColor.c0C0D2D
        addSubview(blurredImageView)
        NSLayoutConstraint.activate([
            blurredImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurredImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurredImageView.heightAnchor.constraint(equalTo: heightAnchor),
            blurredImageView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
    }

    func unblur() {
        subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }

    private func getBlurryImage(_ blurRadius: Double = 2.5) -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }

        return convertedImage
    }
}

/// Remove Child View
extension UIViewController {
    var topController: UIViewController {
        var topController = self
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
    func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    func wrapToNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    func presentFullScreen(from viewController: UIViewController, transparentBackground: Bool = false) {
        if transparentBackground {
            view.backgroundColor = .clear
        }
        modalPresentationStyle = .overCurrentContext
        viewController.present(self, animated: true, completion: nil)
    }
    func push(from viewController: UIViewController) {
        viewController.navigationController?.pushViewController(self, animated: true)
    }
    func present(from viewController: UIViewController) {
        viewController.present(self, animated: true, completion: nil)
    }
    func present() {
        UIApplication.currentWindow.rootViewController = self
    }
}

// MARK: convert uiimage to gif
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (left?, right?):
    return left < right
  case (nil, _?):
    return true
  default:
    return false
  }
}

extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ aaa: Int?, _ bbb: Int?) -> Int {
        var aaa = aaa
        var bbb = bbb
        if bbb == nil || aaa == nil {
            if bbb != nil {
                return bbb!
            } else if aaa != nil {
                return aaa!
            } else {
                return 0
            }
        }
        
        if aaa < bbb {
            let ccc = aaa
            aaa = bbb
            bbb = ccc
        }
        
        var rest: Int
        while true {
            rest = aaa! % bbb!
            
            if rest == 0 {
                return bbb!
            } else {
                aaa = bbb
                bbb = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for idx in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, idx, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(idx),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for idx in 0..<count {
            frame = UIImage(cgImage: images[Int(idx)])
            frameCount = Int(delays[Int(idx)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}

extension UIView {

    func takeScreenshot() -> UIImage {

        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
}

extension UILabel {
    func setAttributedTextWithClickableLinks(_ text: String) {
        let attributedText = NSMutableAttributedString(string: text, attributes: [
            .foregroundColor: UIColor.blue,
            .font: UIFont.systemFont(ofSize: 16)
        ])

        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        attributedText.addAttributes(linkAttributes, range: NSRange(location: 0, length: attributedText.length))

        self.attributedText = attributedText
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:))))
    }
    
    @objc private func labelTapped(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel else { return }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let location = gesture.location(in: label)
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if let link = label.attributedText?.attribute(.link, at: characterIndex, effectiveRange: nil) as? URL {
            UIApplication.shared.open(link)
        }
    }
}
