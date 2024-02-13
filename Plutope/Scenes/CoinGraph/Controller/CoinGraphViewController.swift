//
//  CoinGraphViewController.swift
//  Plutope
//
//  Created by Priyanka on 03/06/23.
//

import UIKit
import ActiveLabel
import Charts

class CoinGraphViewController: UIViewController, Reusable {
    
    @IBOutlet weak var lblCoinSign: UILabel!
    @IBOutlet weak var lblCoinType: DesignableLabel!
    @IBOutlet weak var lblDescriptionHeight: NSLayoutConstraint!
    @IBOutlet weak var lblUpdatedPrice: UILabel!
    @IBOutlet weak var lblAboutCoin: UILabel!
    @IBOutlet var btnDays: [UIButton]!
    @IBOutlet weak var lblPer: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCoinName: UILabel!
    @IBOutlet weak var ivCoinImage: UIImageView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblMarketCap: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var lblCirculatingSupply: UILabel!
    @IBOutlet weak var lblTotalSupply: UILabel!
    @IBOutlet weak var lblCoinDescription: UILabel!
    
    @IBOutlet weak var lblMarketCapText: UILabel!
    @IBOutlet weak var lblVolume24Text: UILabel!
    @IBOutlet weak var lblCirculatingSupplyText: UILabel!
    @IBOutlet weak var lblTotalSupplyText: UILabel!
    
    var priceLines: [CAShapeLayer] = []
    lazy var viewModel: CoinGraphViewModel = {
        CoinGraphViewModel { _ ,message in
            self.showToast(message: message, font: .systemFont(ofSize: 15))
        }
    }()
    
    var currencyDetail = WalletData.shared.primaryCurrency
    var coinDetail: Token?
    var priceFormatter: NumberFormatter!
    var dataEntries: [ChartDataEntry] = []
    var marketDataList: MarketData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Navigation Header
        defineHeader(headerView: headerView, titleText: "")
        
        self.lblMarketCapText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.marketcap, comment: "")
        self.lblVolume24Text.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.volume24h, comment: "")
        self.lblTotalSupplyText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.totalsupply, comment: "")
        self.lblCirculatingSupplyText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.circulatingsupply, comment: "")
        
        self.getMarketData("\(WalletData.shared.primaryCurrency?.symbol ?? "")", ids: self.coinDetail?.tokenId ?? "")
        self.getGraphData(self.coinDetail?.tokenId ?? "", currency: "\(WalletData.shared.primaryCurrency?.symbol ?? "")", days: "1")
        self.getTokenInfo(tokenId: self.coinDetail?.tokenId ?? "")
        setCoinDetail()
    }
    
    @IBAction func actionDone(_ sender: Any) {
        
    }
    
    /// setCoinDetail
    private func setCoinDetail() {
        self.lblCoinName.text = coinDetail?.symbol ?? ""
        self.lblCoinSign.text = coinDetail?.name ?? ""
        self.lblCoinType.text = coinDetail?.type ?? ""
        self.lblPer.text = "\(coinDetail?.lastPriceChangeImpact ?? "")%"
        let price = WalletData.shared.formatDecimalString("\(coinDetail?.price ?? "")", decimalPlaces: 5)
        //let price = String(format: "%.5f", Double(coinDetail?.price ?? "") ?? 0.0)
        self.lblPrice.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(price)"
        self.lblUpdatedPrice.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(price)"
        self.ivCoinImage.sd_setImage(with: URL(string: coinDetail?.logoURI ?? ""))
        chartView.xAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.delegate = self
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        btnDays[1].backgroundColor = .c202148
        lblAboutCoin.text = "About \(coinDetail?.name ?? "")"
    }
    
    @IBAction func selectDaysAction(_ sender: UIButton) {
        removePriceLabels()
        chartView.clear()
        dataEntries.removeAll()
        sender.backgroundColor = .c202148
        switch sender.tag {
        case 0 :
            getGraphData(self.coinDetail?.tokenId ?? "", currency: "\(WalletData.shared.primaryCurrency?.symbol ?? "")", days: "1")
        case 1 :
            getGraphData(self.coinDetail?.tokenId ?? "", currency: "\(WalletData.shared.primaryCurrency?.symbol ?? "")", days: "1")
        case 2 :
            getGraphData(self.coinDetail?.tokenId ?? "", currency: "\(WalletData.shared.primaryCurrency?.symbol ?? "")", days: "7")
        case 3 :
            getGraphData(self.coinDetail?.tokenId ?? "", currency: "\(WalletData.shared.primaryCurrency?.symbol ?? "")", days: "30")
        case 4 :
            getGraphData(self.coinDetail?.tokenId ?? "", currency: "\(WalletData.shared.primaryCurrency?.symbol ?? "")", days: "365")
        case 5 :
            getGraphData(self.coinDetail?.tokenId ?? "", currency: "\(WalletData.shared.primaryCurrency?.symbol ?? "")", days: "max")
        default:
            break
        }
        
        btnDays.forEach { btnday in
            if btnday.tag != sender.tag {
                btnday.backgroundColor = .clear
            }
        }
    }
    func removePriceLabels() {
        chartView.subviews.forEach { subview in
            if subview is UILabel {
                subview.removeFromSuperview()
            }
        }
    }
    
}

// MARK: APIS
extension CoinGraphViewController {
    private func getGraphData(_ chain: String,currency: String,days: String) {
        viewModel.apiGraphData(chain, currency: currency, days: days, completion: { status, _, graphData in
            if status == true {
                self.bindChartData(jsonArray: graphData!)
                
            }
        })
    }
    private func getMarketData(_ currency: String,ids: String) {
        
        viewModel.apiMarketVolumeData(currency, ids: ids) { [weak self] status, _, marketData in
            
            guard let self = self, let marketData = marketData, status else {
                return
            }
            
            let filteredMarketData = marketData
            
            if let firstMarketData = filteredMarketData.first {
                self.marketDataList = firstMarketData
                self.lblMarketCap.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(self.marketDataList?.marketCap ?? 0)"
                self.lblTotalSupply.text = "\(self.marketDataList?.totalSupply ?? 0) \(self.coinDetail?.symbol ?? "")"
                self.lblVolume.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(self.marketDataList?.totalVolume ?? 0)"
                self.lblCirculatingSupply.text = "\(self.marketDataList?.circulatingSupply ?? 0) \(self.coinDetail?.symbol ?? "")"
            }
        }
        
    }
    
    private func getTokenInfo(tokenId: String) {
        viewModel.apiCoinInfo(tokenID: tokenId) { [weak self] status, _, data in
            if status == true {
                let str = data?.description?.en ?? ""
                if let attributedString = str.attributedStringFromHTML(font: AppFont.regular(14).value, textColor: .white) {
                    self?.lblCoinDescription.attributedText = attributedString
                    self?.lblCoinDescription.isUserInteractionEnabled = true
                    self?.lblCoinDescription.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self?.labelTapped(_:))))
                }
                let labelWidth = self?.lblCoinDescription.frame.size.width ?? 0
                let newSize = self?.lblCoinDescription.sizeThatFits(CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize.zero
                
                // Update label height constraint
                self?.lblDescriptionHeight.constant = newSize.height
                
                // Optional: Call layoutIfNeeded to immediately update layout
                self?.view.layoutIfNeeded()
//                self?.lblCoinDescription.handleURLTap { url in
//                    UIApplication.shared.open(url)
//                }
                print("SUCCESS: description: \(str )")
            } else {
                print("FAIL")
            }
        }
    }
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        // Handle link tap
        // You can use the same logic as previously mentioned
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
    
    func convertHtmlToPlainText(_ html: String) -> String? {
        guard let data = html.data(using: .utf8) else {
            return nil
        }
        
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return attributedString.string
        }
        
        return nil
    }
    
    func bindChartData(jsonArray: GraphData) {
        
        // Inside the completion handler of your API request
        
        if self.btnDays[0].backgroundColor == .c202148 {
            
            if let prices = jsonArray.prices {
                let last12Prices = Array(prices.suffix(12))
                for item in last12Prices {
                    let xValue = item.first ?? 0.0
                    let yValue = item[1]
                    let dataEntry = ChartDataEntry(x: xValue ?? 0.0, y: yValue ?? 0.0)
                    dataEntries.append(dataEntry)
                }
            }
            
        } else {
            for item in jsonArray.prices ?? [] {
                let xValue = item.first ?? 0.0
                let yValue = item[1]
                let dataEntry = ChartDataEntry(x: xValue ?? 0.0, y: yValue ?? 0.0)
                dataEntries.append(dataEntry)
            }
        }
        
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Price")
        
        // Create a gradient fill color
        dataSet.fill = ColorFill(cgColor: UIColor.cF0B90B.cgColor)
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 1
        dataSet.fillColor = .cF0B90B
        dataSet.setColor(.white)
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        dataSet.highlightColor = .gray
        dataSet.fillFormatter = DefaultFillFormatter { _,_ -> CGFloat in
            return CGFloat(self.chartView.leftAxis.axisMinimum)
        }
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
        
        // Calculate the minimum and maximum values
        let minPrice = dataEntries.min { $0.y < $1.y }?.y ?? 0.0
        let maxPrice = dataEntries.max { $0.y < $1.y }?.y ?? 0.0
        
        // Add minimum and maximum price labels
        addPriceLabel(value: minPrice, color: .black)
        addPriceLabel(value: maxPrice, color: .black)
        
        chartView.notifyDataSetChanged()
    }
    
    func addPriceLabel(value: Double, color: UIColor) {
        let priceLabel = UILabel()
        priceLabel.textColor = color
        priceLabel.textAlignment = .center
        priceLabel.backgroundColor = .white
        priceLabel.layer.cornerRadius = 5
        priceLabel.layer.masksToBounds = true
        
        // Adjust the font size to fit the label width
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
        
        // Set the price label value
        let valueLable = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 2)
        priceLabel.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(valueLable))"
        
        // Add the label to the chart view
        chartView.addSubview(priceLabel)
        
        // Position the label on the chart view
        let labelWidth: CGFloat = 70
        let labelHeight: CGFloat = 20
        
        // Find the closest data entry to the value
        let closestEntry = dataEntries.min(by: { abs($0.y - value) < abs($1.y - value) })
        
        // Calculate the pixel position of the closest entry
        guard let closestEntry = closestEntry else {
            return
        }
        
        let transformer = chartView.getTransformer(forAxis: .left)
        var pixelPoint = transformer.pixelForValues(x: closestEntry.x, y: closestEntry.y)
        
        // Adjust the label position if it exceeds the screen width
        let screenWidth = UIScreen.main.bounds.width
        let labelX = pixelPoint.x - (labelWidth / 2)
        if labelX < 0 {
            pixelPoint.x = labelWidth / 2
        } else if labelX + labelWidth > screenWidth {
            pixelPoint.x = screenWidth - (labelWidth / 2)
        }
        
        let labelY = pixelPoint.y - labelHeight - 10
        priceLabel.frame = CGRect(x: pixelPoint.x - (labelWidth / 2), y: labelY, width: labelWidth, height: labelHeight)
    }
}

// MARK: ChartViewDelegate
extension CoinGraphViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
       
        let entryY = WalletData.shared.formatDecimalString("\(entry.y)", decimalPlaces: 2)
        lblPrice.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(entryY))"
        
    }
}

// Extension to convert HTML to attributed string
extension String {
    func attributedStringFromHTML(font: UIFont, textColor: UIColor) -> NSAttributedString? {
        do {
            let attributedString = try NSAttributedString(data: Data(utf8), options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil)

            // Apply custom font size and color attributes
            let range = NSRange(location: 0, length: attributedString.length)
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor
            ]
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            mutableAttributedString.addAttributes(attributes, range: range)

            return mutableAttributedString
        } catch {
            print("Error converting HTML to attributed string: \(error)")
            return nil
        }
    }
}

