require 'selenium-webdriver'

class PriceCrawl

  def initialize
    @busy = false
    @queue = []

    chromedriver_path = File.join(File.absolute_path('', File.dirname('./lib/Drivers')),'Drivers', ENV['MACHINE'] == 'linux' ? 'chromedriver' : 'chromedriver_mac')
    Selenium::WebDriver::Chrome::Service.driver_path = chromedriver_path

    caps = Selenium::WebDriver::Remote::Capabilities.chrome(
        'chromeOptions' => {
            'args' => %w(--window-size=1920,1080 --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugin-port=9222)
        }
    )

    @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
    @driver.navigate.to "https://www.carfax.com/value/"
  end

  def look_for_vin(vin, target_id)
    if @busy
      @queue << {vin: vin, id: target_id}
    else
      @busy = true

      wait = Selenium::WebDriver::Wait.new(:timeout => 3)

      zip_code_input = wait.until {
        field = @driver.find_element(:name, 'zip')
        field if field.displayed?
      }

      vin_input = wait.until {
        field = @driver.find_element(:name, 'vin')
        field if field.displayed?
      }

      search_button = wait.until {
        field = @driver.find_element(:id, 'btnGetCarfax')
        field if field.displayed?
      }

      zip_code_input.send_keys('33131')
      vin_input.send_key(vin)
      search_button.click()

      whole_price = wait.until {
        field = @driver.find_element(:class_name, 'vehicle-info__value')
        field if field.displayed?
      }

      response = whole_price.text
      broadcast_result(vin, response, target_id)
      @driver.navigate.to "https://www.carfax.com/value/"
      @busy = false
      job = @queue.shift
      look_for_vin(job[:vin], job[:id]) if job
    end
  rescue
    response = "Not available"
    broadcast_result(vin, response, target_id)
    @driver.navigate.to "https://www.carfax.com/value/"
    @busy = false
    job = @queue.shift
    look_for_vin(job[:vin], job[:id]) if job
  end

  def broadcast_result(vin, result, id)
    mmr = result.sub!('$', '').sub(',', '').to_i
    ::Car.find_by_vin(vin)
        .update!(
            whole_price: mmr
        )
  rescue StandardError
    mmr = 'null'
  ensure
    params = {:mmr => mmr, vin: vin}
    p params
    ActionCable.server.broadcast("price_query_channel_#{id}",
                                 params.to_json)
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

    submit_button = wait.until {
      field = @driver.find_element(:name, 'submit')
      field if field.displayed?
    }

    puts submit_button

    user_field = wait.until {
      field = @driver.find_element(:id, 'user_username')
      field if field.displayed?
    }

    password_field = wait.until {
      field = @driver.find_element(:id, 'user_password')
      field if field.displayed?
    }

    user_field.send_keys('pierpontllc')
    password_field.send_keys('Kittie123!')
    submit_button.click()
  end
end