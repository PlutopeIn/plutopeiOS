//
//  CustomTextField.swift
//  Plutope
//
//  Created by Priyanka Poojara on 05/06/23.
//
import UIKit
//@IBDesignable class customTextField: UITextField {
//
//    @IBInspectable
//    var leftSpacing: CGFloat = 0{
//        didSet{
//            setTextField(RightSpacing: rightSpacing, LeftSpacing: leftSpacing)
//        }
//    }
//
//    @IBInspectable
//    var rightSpacing: CGFloat = 0{
//        didSet{
//            setTextField(RightSpacing: rightSpacing, LeftSpacing: leftSpacing)
//        }
//    }
//
//    private func setTextField(RightSpacing: CGFloat = 0, LeftSpacing: CGFloat = 0) {
//
//        let leftIconContainerView: UIView = UIView(frame:CGRect(x: 20, y: 0, width: LeftSpacing, height: self.frame.height))
//        leftView = leftIconContainerView
//        leftViewMode = .always
//        let rightIconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: RightSpacing, height: self.frame.height))
//        rightView = rightIconContainerView
//        rightViewMode = .always
//    }
//
//}
@IBDesignable

class customTextField: UITextField {
    
    // MARK: - Properties
    
    @IBInspectable
    var leftSpacing: CGFloat = 0 {
        didSet {
            setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
        }
    }
    
    @IBInspectable
    var rightSpacing: CGFloat = 0 {
        didSet {
            setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
        }
    }
//    override func awakeFromNib() {
//           super.awakeFromNib()
//           setupLanguageChangeObserver()
//           setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
//       }
    
    override func awakeFromNib() {
           super.awakeFromNib()
        setup()
           setupLanguageChangeObserver()
           setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
       }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var imageWidth: CGFloat = 20.0 {
        didSet {
            updateLeftView()
            updateRightView()
        }
    }
    
    @IBInspectable var imageHeight: CGFloat = 20.0 {
        didSet {
            updateLeftView()
            updateRightView()
        }
    }
    
    @IBInspectable var ivLeadingPadding: CGFloat = 0.0 {
        didSet {
            updateLeftView()
            updateRightView()
        }
    }
    
    @IBInspectable var ivTrailingPadding: CGFloat = 0.0 {
        didSet {
            updateLeftView()
            updateRightView()
        }
    }
    
    // MARK: - Lifecycle
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setup()
//    }
    
    
    private func setupLanguageChangeObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { [weak self] _ in
            self?.setTextField()
        }
    }
    private func setTextField(rightSpacing: CGFloat = 0, leftSpacing: CGFloat = 0) {
        let leftIconContainerView = UIView(frame: CGRect(x: 20, y: 0, width: leftSpacing, height: self.frame.height))
        let rightIconContainerView = UIView(frame: CGRect(x: 20, y: 0, width: rightSpacing, height: self.frame.height))

        // Check the current language direction
        let isRTL = LocalizationSystem.sharedInstance.getLanguage() == "ar"
        
        // Adjust positions based on language direction
        if isRTL {
            leftIconContainerView.frame.origin.x = self.frame.width - leftSpacing
            rightIconContainerView.frame.origin.x = self.frame.width - rightSpacing
            textAlignment = .left
        } else {
            textAlignment = .left
        }
        
        leftView = leftIconContainerView
        leftViewMode = .always
        
        rightView = rightIconContainerView
        rightViewMode = .always
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        updateLeftView()
        updateRightView()
        self.textColor = .label
    }
    
    // MARK: - Update Views
    
    private func updateLeftView() {
        let leftImageView = createImageView(image: leftImage)
        leftView = createViewWithLeadingPadding(imageView: leftImageView)
        leftViewMode = .always
    }
    
    private func updateRightView() {
        let rightImageView = createImageView(image: rightImage)
        rightView = createViewWithTrailingPadding(imageView: rightImageView)
        rightViewMode = .always
    }
    
    private func createImageView(image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView.isUserInteractionEnabled = false
        return imageView
    }
    
    private func createViewWithLeadingPadding(imageView: UIImageView) -> UIView {
        let containerWidth = (leftImage != nil ? imageWidth : 0) + ivLeadingPadding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: imageHeight))
        containerView.isUserInteractionEnabled = false
        containerView.addSubview(imageView)
        return containerView
    }
    
    private func createViewWithTrailingPadding(imageView: UIImageView) -> UIView {
        let containerWidth = (rightImage != nil ? imageWidth : 0) + ivTrailingPadding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: imageHeight))
        containerView.isUserInteractionEnabled = false
        containerView.addSubview(imageView)
        
        return containerView
    }
    
    func isValidPassword(_ str: String) -> Bool {
            let passRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
//            let passRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
            
    //        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    //        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
            let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
            return passPred.evaluate(with: str)
        }
    
}
/*class customTextField: UITextField {
    
    @IBInspectable
    var leftSpacing: CGFloat = 0 {
        didSet {
            setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
        }
    }
    
    @IBInspectable
    var rightSpacing: CGFloat = 0 {
        didSet {
            setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
        }
    }
    override func awakeFromNib() {
           super.awakeFromNib()
           setupLanguageChangeObserver()
           setTextField(rightSpacing: rightSpacing, leftSpacing: leftSpacing)
       }
    private func setupLanguageChangeObserver() {
        NotificationCenter.default.addObserver(forName: Notification.Name("LanguageDidChange"), object: nil, queue: .main) { [weak self] _ in
            self?.setTextField()
        }
    }
    private func setTextField(rightSpacing: CGFloat = 0, leftSpacing: CGFloat = 0) {
        let leftIconContainerView = UIView(frame: CGRect(x: 20, y: 0, width: leftSpacing, height: self.frame.height))
        let rightIconContainerView = UIView(frame: CGRect(x: 20, y: 0, width: rightSpacing, height: self.frame.height))

        // Check the current language direction
        let isRTL = LocalizationSystem.sharedInstance.getLanguage() == "ar"
        
        // Adjust positions based on language direction
        if isRTL {
            leftIconContainerView.frame.origin.x = self.frame.width - leftSpacing
            rightIconContainerView.frame.origin.x = self.frame.width - rightSpacing
            textAlignment = .left
        } else {
            textAlignment = .left
        }
        
        leftView = leftIconContainerView
        leftViewMode = .always
        
        rightView = rightIconContainerView
        rightViewMode = .always
    }
    func isValidPassword(_ str: String) -> Bool {
            let passRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
//            let passRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
            
    //        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    //        let passRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
            let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
            return passPred.evaluate(with: str)
        }
}*/
