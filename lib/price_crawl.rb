require 'selenium-webdriver'

class PriceCrawl
  def initialize
    chromedriver_path = File.join(File.absolute_path('', File.dirname('./lib/Drivers')),'Drivers','chromedriver')
    Selenium::WebDriver::Chrome::Service.driver_path = chromedriver_path
    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to "https://www.manheim.com/login?WT.svl=m_uni_hdr"
  end
end