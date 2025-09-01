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
           // self.showToast(message: message, font: .systemFont(ofSize: 15))
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
        defineHeader(headerView: headerView, titleText: coinDetail?.name ?? "")
        
        self.lblMarketCapText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.marketcap, comment: "")
        self.lblVolume24Text.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.volume24h, comment: "")
        self.lblTotalSupplyText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.totalsupply, comment: "")
        self.lblCirculatingSupplyText.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.circulatingsupply, comment: "")
        
        self.getMarketData("\(WalletData.shared.primaryCurrency?.symbol ?? "")", ids: self.coinDetail?.tokenId ?? "")
        self.getGraphData(self.coinDetail?.tokenId ?? "", currency: "\(WalletData.shared.primaryCurrency?.symbol ?? "")", days: "1")
        self.getTokenInfo(tokenId: self.coinDetail?.tokenId ?? "")
        lblCirculatingSupplyText.font = AppFont.regular(12.67).value
        lblCirculatingSupply.font = AppFont.violetRegular(17.11).value
        lblUpdatedPrice.font = AppFont.regular(15.0).value
        lblPer.font = AppFont.regular(15.0).value
        lblVolume24Text.font = AppFont.regular(13.0).value
        lblVolume.font = AppFont.violetRegular(18.0).value
        lblTotalSupplyText.font = AppFont.regular(13.0).value
        lblTotalSupply.font = AppFont.violetRegular(18.0).value
        lblMarketCapText.font = AppFont.regular(13.0).value
        lblMarketCap.font = AppFont.violetRegular(18.0).value
        lblAboutCoin.font = AppFont.violetRegular(25).value
        lblCoinDescription.font = AppFont.violetRegular(18.0).value
        
        setCoinDetail()
    }
    
    func convertToBillion(_ amount: Double) -> String {
        let billionValue = amount / 1_000_000_000.0
        return String(format: "%.1fB", billionValue)
    }
    func convertToMillion(_ amount: Double) -> String {
        let millionValue = amount / 1_000_000.0
        return String(format: "%.1fM", millionValue)
    }
    func formatAmount(_ amount: Double) -> String {
        if amount >= 1_000_000_000 {
            let billionValue = amount / 1_000_000_000.0
            return String(format: "%.1fB", billionValue)
        } else {
            let millionValue = amount / 1_000_000.0
            return String(format: "%.1fM", millionValue)
        }
    }
    @IBAction func actionDone(_ sender: Any) {
        HapticFeedback.generate(.light)
    }
    
    /// setCoinDetail
    private func setCoinDetail() {
    
        self.lblCoinType.text = coinDetail?.type ?? ""
        let balanceString = WalletData.shared.formatDecimalString("\(coinDetail?.balance ?? "0")", decimalPlaces: 8)
        
        lblPrice.text = "\(balanceString) \(coinDetail?.symbol ?? "")"
        let price = WalletData.shared.formatDecimalString("\(coinDetail?.price ?? "0")", decimalPlaces: 5)
        if Double(coinDetail?.lastPriceChangeImpact ?? "") ?? 0.0 >= 0 {
            self.lblPer.text = "+\(coinDetail?.lastPriceChangeImpact ?? "0")%"
            self.lblPer.textColor = UIColor.c099817
        } else {
            self.lblPer.text = "\(coinDetail?.lastPriceChangeImpact ?? "0")%"
            self.lblPer.textColor = .red
        }
        self.lblUpdatedPrice.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(price)"
        self.ivCoinImage.sd_setImage(with: URL(string: coinDetail?.logoURI ?? ""))
        chartView.xAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.drawLabelsEnabled = false
        chartView.delegate = self
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        btnDays[1].backgroundColor = UIColor.secondaryLabel
        
        if LocalizationSystem.sharedInstance.getLanguage() == "hi" {
            lblAboutCoin.text = "\(coinDetail?.name ?? "") \(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.about, comment: ""))"
        } else {
            lblAboutCoin.text = "\(LocalizationSystem.sharedInstance.localizedStringForKey(key: LocalizationLanguageStrings.about, comment: "")) \(coinDetail?.name ?? "")"
        }
      
    }
    
    @IBAction func selectDaysAction(_ sender: UIButton) {
        HapticFeedback.generate(.light)
        removePriceLabels()
        chartView.clear()
        dataEntries.removeAll()
        sender.backgroundColor = UIColor.secondaryLabel
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
                
                if let marketCap = self.marketDataList?.marketCap {
                    let marketCapValue: Double = {
                        switch marketCap {
                        case .int(let value):
                            return Double(value)
                        case .double(let value):
                            return value
                        }
                    }()
                    let marketcap = Double(marketCapValue)
                    let marketccapFinal = convertToBillion(marketcap)
                    self.lblMarketCap.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(marketccapFinal)"
                } else {
                    self.lblMarketCap.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")0"
                }
                
//                self.lblMarketCap.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(self.marketDataList?.marketCap ?? 0)"
                
                let totalSupply = Double(self.marketDataList?.totalSupply ?? 0)
                let finaltotalSupply = WalletData.shared.formatDecimalString("\(totalSupply)", decimalPlaces: 1)
                self.lblTotalSupply.text = "\(finaltotalSupply) \(self.coinDetail?.symbol ?? "")"
                let volume = Double(self.marketDataList?.totalVolume ?? 0)
                let volumeFinal = convertToMillion(volume)
                self.lblVolume.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(volumeFinal)"
               let circularsuply =  WalletData.shared.formatDecimalString("\(self.marketDataList?.circulatingSupply ?? 0)", decimalPlaces: 1)
                self.lblCirculatingSupply.text = "\(circularsuply) \(self.coinDetail?.symbol ?? "")"
            }
        }
        
    }
    
    private func getTokenInfo(tokenId: String) {
        viewModel.apiCoinInfo(tokenID: tokenId) { [weak self] status, _, data in
            if status == true {
                let str = data?.description?.en ?? ""
                if let attributedString = str.attributedStringFromHTML(font: AppFont.violetRegular(15).value, textColor: .label) {
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
        HapticFeedback.generate(.light)
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
        
        if self.btnDays[0].backgroundColor == UIColor.secondaryLabel {
            
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
//        dataSet.fill = ColorFill(cgColor: UIColor.cF0B90B.cgColor)
//        dataSet.drawCirclesEnabled = false
//        dataSet.lineWidth = 1
//        dataSet.fillColor = .cF0B90B
//        dataSet.setColor(.white)
//        dataSet.fillAlpha = 1
//        dataSet.drawFilledEnabled = true
//        dataSet.highlightColor = .gray
        dataSet.highlightEnabled = true
        dataSet.drawFilledEnabled = false
        
        // Customize the appearance of the line chart
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 1
        dataSet.setColor(.green)  // Set the color of the line
        dataSet.highlightColor = .gray
        dataSet.fillFormatter = DefaultFillFormatter { _,_ -> CGFloat in
            return CGFloat(self.chartView.leftAxis.axisMinimum)
        }
        chartView.layer.borderColor = UIColor.systemGray3.cgColor  // Set the border color
        chartView.layer.borderWidth = 1.0
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
        
        // Calculate the minimum and maximum values
        let minPrice = dataEntries.min { $0.y < $1.y }?.y ?? 0.0
        let maxPrice = dataEntries.max { $0.y < $1.y }?.y ?? 0.0
        
        // Add minimum and maximum price labels
        addPriceLabel(value: minPrice, color: .systemBackground)
        addPriceLabel(value: maxPrice, color: .systemBackground)
        
        chartView.notifyDataSetChanged()
    }
    
    func addPriceLabel(value: Double, color: UIColor) {
        let priceLabel = UILabel()
        priceLabel.textColor = color
        priceLabel.textAlignment = .center
        priceLabel.backgroundColor = .label
        priceLabel.layer.cornerRadius = 5
        priceLabel.layer.masksToBounds = true
        
        // Adjust the font size to fit the label width
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.2
        
        // Set the price label value
        let valueLable = WalletData.shared.formatDecimalString("\(value)", decimalPlaces: 2)
        priceLabel.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(valueLable)"
        
        // Add the label to the chart view
        chartView.addSubview(priceLabel)
        
        // Position the label on the chart view
        let labelWidth: CGFloat = 70
        let labelHeight: CGFloat = 10
        
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
//        lblPrice.text = "\(WalletData.shared.primaryCurrency?.sign ?? "")\(entryY) \(coinDetail?.symbol ?? "")"
        
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
