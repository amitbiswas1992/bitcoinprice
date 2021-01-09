

<p align = "center"> 
<img src="BitCoinPices/Assets.xcassets/bit/bitcoin1.png"  width ="100" height="100" >
</p>
<div align="center">
 <h2> Bitcoin Price App  </h2>
</div>
<p align = "center"> 
<a href="https://github.com/amitbiswas1992/githubexplorer"><img src="https://travis-ci.com/slatedocs/slate.svg?branch=master" alt="Build Status"></a>
</p>


 
## Listing VC Summary
 
            
On the first screen tableview is used to show the list. Two APIs  is used to show the data of two weeks including today. The API which gives the data for last two weeks excluding today takes the parameters of currency , start date and end date. So, we have to calculate it manually the start date and end date by using Calendar object. I just pass the current date in Calendar object and giving -14 to the calendar object parameter so it gives me the start date of previous two weeks. Second API  is used for current price. I used the response of the current price api and append the response in the last two weeks response. 

<p align = "center"> 
<img src="BitCoinPices/Assets.xcassets/bit-2.imageset/bit-2.png"  width ="280" height="575" >
</p>


## Used technology iOS

* iOS 14 build 
* Swift 5.0
* Xcode 12.2
* UITableViewController 
* UINavigationController
* UIRefreshControl


### Refreshing current price 

- For showing the updated current price after every minute I used the timer which hits after every minute and fetch the today latest price. Then I update this response and update with the today object.

### Price Details 
        
 - I just passed the object of the price which was used in listing. And then showing the prices of the USD, GDP and Euro.

### Run the App 
    
- Just open the file  BitCoinPices.xcodeproj  from Xcode. Select the device from the top and press cmd + R to run the application.

### Bonus 

- For offline viewing we saved the last fetched data locally so if the internet connection is off then user can see the last fetched two weeks prices in the application. For local storing we used the iOS Native NSUserDefaults.



### Note 

```swift
// code away!

let apiKey = “NO API KEY NEEDED
```

###  Thank You !  






