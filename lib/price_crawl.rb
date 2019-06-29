require 'selenium-webdriver'

class PriceCrawl

  def initialize
    @busy = false
    @queue = []

    chromedriver_path = File.join(File.absolute_path('', File.dirname('./lib/Drivers')),'Drivers','chromedriver')
    Selenium::WebDriver::Chrome::Service.driver_path = chromedriver_path

    caps = Selenium::WebDriver::Remote::Capabilities.chrome(
        'chromeOptions' => {
            'args' => %w(--window-size=1920,1080 --headless --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugin-port=9222)
        }
    )

    @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
    @driver.navigate.to "https://www.manheim.com/"
  end

  def look_for_vin(vin)
    while @busy
      sleep 2.second
    end

    @busy = true

    5.times do
      if not logged_in?
        login
      else
        break
      end
    end

    wait = Selenium::WebDriver::Wait.new(:timeout => 3)

    search_input = wait.until {
      field = @driver.find_element(:name, 'searchTerms')
      field if field.displayed?
    }

    search_button = wait.until {
      field = @driver.find_element(:class_name, 'uhf-icon-search')
      field if field.displayed?
    }

    search_input.send_keys(vin)
    search_button.click()

    mmr = wait.until {
      field = @driver.find_element(:class_name, 'mmr-valuation')
      field if field.displayed?
    }

    @busy = false
    mmr.find_element(:tag_name, 'a').text
  rescue
    @busy = false
    "Not available"
  end

  def logged_in?
    present = @driver.find_elements(:link_text, 'Login').size > 0
    !present
  end

  def login
    wait = Selenium::WebDriver::Wait.new(:timeout => 10)

    login = wait.until {
      login_button = @driver.find_element(:link_text, 'Login')
      login_button if login_button.displayed?
    }

    login.click()

    user_field = wait.until {
      field = @driver.find_element(:id, 'user_username')
      field if field.displayed?
    }

    password_field = wait.until {
      field = @driver.find_element(:id, 'user_password')
      field if field.displayed?
    }

    submit_button = wait.until {
      field = @driver.find_element(:name, 'submit')
      field if field.displayed?
    }

    user_field.send_keys('pierpontllc')
    password_field.send_keys('Kittie123!')
    submit_button.click()
  end
end