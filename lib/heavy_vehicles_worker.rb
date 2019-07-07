require 'selenium-webdriver'

class HeavyVehiclesWorker

  def initialize

    @webpage_loaded = false
    @vehicles = []

    chromedriver_path = File.join(File.absolute_path('', File.dirname('./lib/Drivers')),'Drivers', ENV['MACHINE'] == 'linux' ? 'chromedriver' : 'chromedriver_mac')
    Selenium::WebDriver::Chrome::Service.driver_path = chromedriver_path

    caps = Selenium::WebDriver::Remote::Capabilities.chrome(
        'chromeOptions' => {
            'args' => %w(--window-size=1920,10800 --headless --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugin-port=9222)
        }
    )

    @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
    @driver.navigate.to "https://ur.rousesales.com/used-equipment-results"

    try_get_result_list

    @webpage_loaded = false
    @results_list = nil

    page_title =  @driver.find_element(:class, "results-title")
    total_cars_text = page_title.find_element(:tag_name, "span").text
    total_cars = total_cars_text[1, total_cars_text.length - 2].gsub(/[\s,]/ ,"")
    @total_vehicles = total_cars.to_i
    @total_pages = (@total_vehicles / 25).ceil
  end

  def get_for_page(page)
    @driver.get("https://ur.rousesales.com/used-equipment-results?page=#{page}")
    @driver.find_elements(:class, 'results-quick-link').each do |link|
      @driver.execute_script("arguments[0].click();", link)
    end
    get_info
  end

  def get_total_pages
    @total_pages
  end

  def get_vehicles
    @vehicles
  end

  def set_vehicles(value)
    @vehicles = value
  end

  def try_get_result_list
    @results_list = @driver.find_element(:id, "results-list")
    if @results_list
      @webpage_loaded = true
    end
  end

  def get_info
    @driver.find_element(:id, 'results-list').find_elements(:xpath, '*').each do |li|
      divs = li.find_elements(:tag_name, "div")

      title = get_title(divs[1])
      main_image = li.find_element(:class, 'results-img').attribute("src")
      location = get_location(divs[1])
      price = get_price(li)
      p title

      equipment_id = divs[4].attribute('id')

      info_block = li.find_element(:id, "details-#{equipment_id}")
      info_block_ul = info_block.find_element(:class, "quickview-list")
      info_block_lis = info_block_ul.find_elements(:tag_name, "li")
      pictures_block = li.find_element(:class, "quick-view-slick")

      equipment_type = get_value(info_block_lis[0])
      category = get_value(info_block_lis[1])
      sub_category = get_value(info_block_lis[2])
      details = get_value(info_block_lis[3])
      serial = get_value_directly(info_block_lis[4])

      @vehicles.push({
                         main_image: main_image,
                         title: title,
                         location: location,
                         price: price,
                         equipment_id: equipment_id,
                         type_id: equipment_type,
                         category: category,
                         sub_category: sub_category,
                         description: details,
                         serial: serial,
                     })
    end
  end

  def get_main_image(div)
    a_tag = div.find_element(:tag_name, "a").attribute("href")
    a_tag
  end

  def get_title(div)
    a_tag = div.find_element(:tag_name, "a")
    title = a_tag.find_element(:tag_name, "h4").text
    title
  end

  def get_location(div)
    location = div.find_element(:class, "location-content").text
    location
  end

  def get_price(li)
    price = li.find_element(:class, 'results-price')
                .attribute('innerHTML')
                .split('<span>')[0]
                .sub(' ', '')
                .sub('$', '')
                .sub(',', '').to_i
    price
  end

  def get_value(li)
    div = li.find_element(:tag_name, "div")
    value = div.find_element(:tag_name, "span").text
    value
  end

  def get_value_directly(li)
    value = li.find_element(:tag_name, "span").text
    value
  end

end