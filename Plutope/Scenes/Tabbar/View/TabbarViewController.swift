//
//  TabbarViewController.swift
//  Plutope
//
//  Created by Priyanka on 10/06/23.
//

import UIKit
import WHTabbar
class TabbarViewController: UIViewController, UITabBarControllerDelegate, UITabBarDelegate {
    
    //@IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tabBarCard: UITabBarItem!
    @IBOutlet weak var tabBarSetting: UITabBarItem!
    @IBOutlet weak var tabbar: UITabBar!
    
    var viewControllers: [UIViewController] = [SettingsViewController(), CardViewController()]
    var selectedTabIndex = 0
    
    let cardVC = CardViewController()
    let settingsVC = SettingsViewController()
    
    fileprivate func setupTabItems() {
        cardVC.tabBarItem = UITabBarItem(
            title: "", image: UIImage.icCard.withTintColor(UIColor.white),
            selectedImage: UIImage.icCard)
        
        settingsVC.tabBarItem = UITabBarItem(
            title: "", image: UIImage.icSetting ,
            selectedImage: UIImage.icSetting)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabItems()
        
//        setupTabBar()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBar()
    }
    
    /// setupTabBar
    fileprivate func setupTabBar() {
        
        let tabBarController = WHTabbarController()
        tabBarController.delegate = self
        
        let cardVC = CardViewController()
        let settingsVC = SettingsViewController()
        
        let cardViewController = UINavigationController(rootViewController: cardVC)
        let settingViewController = UINavigationController(rootViewController: settingsVC)
        
        tabBarController.viewControllers = [cardViewController, settingViewController]
        
        cardViewController.tabBarItem = tabBarCard
        settingViewController.tabBarItem = tabBarSetting
        
        tabBarController.tabBar.isTranslucent = true
        tabBarController.tabBar.tintColor = .clear
        tabBarController.tabBar.backgroundImage?.withTintColor(UIColor.clear)
        tabBarController.tabBar.barTintColor = .clear
        tabBarController.tabBar.backgroundColor = .clear
        tabBarController.tabBar.standardAppearance.backgroundColor = .clear
        
        tabBarController.centerButtonImage = UIImage.icTransfer
        tabBarController.centerButtonBackroundColor =  .clear
        tabBarController.centerButtonSize = 50
        tabBarController.centerButtonBorderColor = .clear
        tabBarController.centerButtonImageSize = 60
        tabBarController.setupCenetrButton(vPosition: 35) {
            print("center button clicked")
        }
        tabBarController.isCurvedTabbar = true
        tabBarController.makeTabbarCurved()
        
        self.view.backgroundColor = .clear
        
        tabBarController.view.frame = self.view.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.addChild(tabBarController)
        self.view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        tabBarController.selectedIndex = 0
        
    }
    
}

@IBDesignable
class CustomizedTabBar: UITabBar {

    private var shapeLayer: CALayer?

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.c0C0D2D.cgColor
        shapeLayer.lineWidth = 1.0

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    func createPath() -> CGPath {
        
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
        
        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        
        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRadius: CGFloat = 35
        return abs(self.center.x - point.x) > buttonRadius || abs(point.y) > buttonRadius
    }

    func createPathCircle() -> CGPath {

        let radius: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))
        path.addArc(withCenter: CGPoint(x: centerWidth, y: 0), radius: radius, startAngle: CGFloat(180).degreesToRadians, endAngle: CGFloat(0).degreesToRadians, clockwise: false)
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
