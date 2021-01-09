//
//  BitCoinPriceListingViewController.swift
//  BitCoinPices
//
//  Created by Amit Biswas on 01/8/21.
//


import UIKit

class BitCoinPriceListingViewController: UIViewController {

    private let priceListingNibName = "BitCointPriceListingCell"
    private let priceListingCellIdentifier = "bitCointPriceListingCellIdentifier"
    
    private var pricesList = [BitCointList]()
    private var pricesListInUSD = [BitCointList]()
    private var pricesListInGBP = [BitCointList]()
    private var timer: Timer?
    private var isTimerRunning = false
    
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var indicator: UIActivityIndicatorView!
    private var refreshControl = UIRefreshControl()

    //MARK: Outlets
    @IBOutlet weak var currentPriceTopLabel: UILabel!
    
    @IBOutlet weak var purpleDummyView: UIView! {
        didSet {
            purpleDummyView.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.backgroundColor = UIColor.clear
            tableView.separatorColor = .clear
        }
    }
    
    @IBOutlet weak var euroPriceTopLabel: UILabel!
    @IBOutlet weak var poundPriceLabel: UILabel!
    @IBOutlet weak var usdPriceLabel: UILabel!
    
    //MARK: Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNib()
        setupNavBar()
        setupActivityIndicator()
        fetchAllPrices()
        setupRefreshControl()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    @objc
    func fetchCurrentPriceAgain() {
        isTimerRunning = true
        self.fetchCurrentPrice()
    }
    
    @objc
    func handleRefresh(refreshControl: UIRefreshControl) {
        fetchAllPrices()
    }
}

//MARK: Segues
extension BitCoinPriceListingViewController {
    
    private func fetchDataLocally() {
        let previousUSDPrices = UserDefaultsManager.shared.getPriceListOfPreviousTwoWeek(forKey: UserDefaultsManager.previousPricesUSD)
        let previousGBPPrices = UserDefaultsManager.shared.getPriceListOfPreviousTwoWeek(forKey: UserDefaultsManager.previousPricesGBP)
        let previousEURPrices = UserDefaultsManager.shared.getPriceListOfPreviousTwoWeek(forKey: UserDefaultsManager.previousPricesEUR)
        
        let currentUSDPrices = UserDefaultsManager.shared.getPriceListOfPreviousTwoWeek(forKey: UserDefaultsManager.currentPricesUSD)
        let currentGBPPrices = UserDefaultsManager.shared.getPriceListOfPreviousTwoWeek(forKey: UserDefaultsManager.currentPricesGBP)
        let currentEURPrices = UserDefaultsManager.shared.getPriceListOfPreviousTwoWeek(forKey: UserDefaultsManager.currentPricesEUR)
        
        self.pricesListInUSD.removeAll()
        self.pricesListInGBP.removeAll()
        self.pricesList.removeAll()
        
        self.pricesListInUSD.append(contentsOf: previousUSDPrices)
        self.pricesListInGBP.append(contentsOf: previousGBPPrices)
        self.pricesList.append(contentsOf: previousEURPrices)
        
        self.pricesListInUSD.insert(contentsOf: currentUSDPrices, at: 0)
        self.pricesListInGBP.insert(contentsOf: currentGBPPrices, at: 0)
        self.pricesList.insert(contentsOf: currentEURPrices, at: 0)
        
        self.currentPriceTopLabel.text = "€" + (self.pricesList.first?.price ?? "")
        
    }
    
    private func fetchAllPrices() {
        let isNetworkAvailable = Reachability.isConnectedToNetwork()
        if isNetworkAvailable {
            fetchPriceList()
            fetchPriceListForGBP()
            fetchPriceListForUSD()
            
        } else {
            fetchDataLocally()
            tableView.reloadData()
            showEmptyViewIfRequired()
            refreshControl.endRefreshing()
        }
        
        
    }
    
    private func savePricesLocallyOfPreviousTwoWeeks(_ priceList: [BitCointList], key: String) {
        UserDefaultsManager.shared.savePriceListOfPreviousTwoWeek(priceList, forKey: key)
    }
    
    private func saveCurrentPriceLocally() {
        if let eurPrice = self.pricesList.first,
           let usdPrice = self.pricesListInUSD.first,
           let gbpPrice = self.pricesListInGBP.first {
            
            UserDefaultsManager.shared.saveCurrentPrice([eurPrice], forkey: UserDefaultsManager.currentPricesEUR)
            UserDefaultsManager.shared.saveCurrentPrice([usdPrice], forkey: UserDefaultsManager.currentPricesUSD)
            UserDefaultsManager.shared.saveCurrentPrice([gbpPrice], forkey: UserDefaultsManager.currentPricesGBP)
        }
    }
    
    private func openPriceDetailVC(bitCoinPrice: BitCoinPrice) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "priceDetailViewController") as? PriceDetailViewController {
            vc.bitCoinPrice = bitCoinPrice
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


//MARK: Api Calls
extension BitCoinPriceListingViewController {
    
    private func fetchPriceListForGBP() {
        let dates = getStartAndEndDate()
        
        NetworkManager.shared.getPastTwoWeekPrices(
            forCurrency: "GBP",
            startDate: dates.start,
            endDate: dates.end) { response in
            switch response {
            case .success(let bitCoinArray):
                
                self.pricesListInGBP.removeAll()
                self.pricesListInGBP.append(contentsOf: bitCoinArray)
                self.savePricesLocallyOfPreviousTwoWeeks(bitCoinArray,
                                                         key: UserDefaultsManager.previousPricesGBP)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.indicator.stopAnimating()
                }
                
                
                break
                
            case .failure(let error):
                Utils.showAlert(title: "Error", message: error.localizedDescription, viewController: self)
                break
            }
        }
    }
    
    private func fetchPriceListForUSD() {
        let dates = getStartAndEndDate()
        
        NetworkManager.shared.getPastTwoWeekPrices(
            forCurrency: "USD",
            startDate: dates.start,
            endDate: dates.end) { response in
            switch response {
            case .success(let bitCoinArray):
                
                self.pricesListInUSD.removeAll()
                self.pricesListInUSD.append(contentsOf: bitCoinArray)
                self.savePricesLocallyOfPreviousTwoWeeks(bitCoinArray, key: UserDefaultsManager.previousPricesUSD)
                break
                
            case .failure(_):
                
                break
            }
        }
    }
    
    private func fetchPriceList() {
        let dates = getStartAndEndDate()
        
        NetworkManager.shared.getPastTwoWeekPrices(
            forCurrency: "EUR",
            startDate: dates.start,
            endDate: dates.end) { response in
            switch response {
            case .success(let bitCoinArray):
                
                self.pricesList.removeAll()
                self.pricesList.append(contentsOf: bitCoinArray)
                self.savePricesLocallyOfPreviousTwoWeeks(bitCoinArray, key: UserDefaultsManager.previousPricesEUR)
                self.fetchCurrentPrice()
                self.showEmptyViewIfRequired()
                
                break
                
            case .failure(_):
                break
            }
        }
    }
    
    private func fetchCurrentPrice() {
        NetworkManager.shared.getCurrentPrice { response in
            switch response {
            case .success(let currentPrice):
                
                DispatchQueue.main.async {
                    
                    if self.isTimerRunning {
                        self.pricesList[0] = currentPrice.eur
                        self.pricesListInUSD[0] = currentPrice.usd
                        self.pricesListInGBP[0] = currentPrice.gbp
                        
                    } else {
                        self.pricesList.insert(currentPrice.eur, at: 0)
                        self.pricesListInUSD.insert(currentPrice.usd, at: 0)
                        self.pricesListInGBP.insert(currentPrice.gbp, at: 0)
                        self.startTimer()
                    }
                    
                    self.saveCurrentPriceLocally()
                    self.currentPriceTopLabel.text = "€" + currentPrice.eur.price
                    self.tableView.reloadData()
                }
                
                break
                
            case .failure( _):
                break
            }
        }
    }
    
    public func getStartAndEndDate() -> (start: String, end: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        let endDateString = formatter.string(from: endDate)
        
        
        let startDate = Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
        let startDateString = formatter.string(from: startDate)

        
        return (startDateString, endDateString)
    }
    
    
    private func setupRefreshControl() {
        self.refreshControl.tintColor = UIColor.blue
        self.refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControl.Event.valueChanged)
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        self.tableView.addSubview(refreshControl)
    }
    
    private func showEmptyViewIfRequired() {
        DispatchQueue.main.async {
            self.emptyLabel.isHidden = self.pricesList.count != 0
        }
        
        
    }
}


//MARK: Private Methods

extension BitCoinPriceListingViewController {
    
    private func setupActivityIndicator() {
        self.indicator  = UIActivityIndicatorView(style: .medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
    }
    
    private func startTimer() {
        
        self.timer = Timer.scheduledTimer(timeInterval: 60.0,
                                          target: self,
                                          selector: #selector(fetchCurrentPriceAgain),
                                          userInfo: nil, repeats: true)
    }
    
    private func registerNib() {
        let nib = UINib(nibName: priceListingNibName, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: priceListingCellIdentifier)
    }
    
    private func setupNavBar() {
        let navigationBar = self.navigationController?.navigationBar
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        
        navigationBar?.isTranslucent = false
    }
    
}


//MARK: - UITableView Delegate

extension BitCoinPriceListingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usdPrice = self.pricesListInUSD[indexPath.row].price
        let gbpPrice = self.pricesListInGBP[indexPath.row].price
        let eurPrice = self.pricesList[indexPath.row].price
        let date = self.pricesList[indexPath.row].date
        
        let bitCoinPrice = BitCoinPrice(usd: usdPrice, gbp: gbpPrice, eur: eurPrice, date: date)
        self.openPriceDetailVC(bitCoinPrice: bitCoinPrice)
    }
}

//MARK: - Table View Data Source
extension BitCoinPriceListingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: priceListingCellIdentifier, for: indexPath) as! BitCointPriceListingCell
        cell.setData(price: self.pricesList[indexPath.row].price,
                     Date: self.pricesList[indexPath.row].date)
        cell.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pricesList.count
        
    }
}
