require 'selenium-webdriver'

class HeavyVehicles

  def initialize(page)
    @webpage_loaded = false
    @vehicles = []
    @pageNumber = page

    chromedriver_path = File.join(File.absolute_path('', File.dirname('./lib/Drivers')),'Drivers','chromedriver')
    Selenium::WebDriver::Chrome::Service.driver_path = chromedriver_path

    caps = Selenium::WebDriver::Remote::Capabilities.chrome(
        'chromeOptions' => {
            'args' => %w(--window-size=1920,1080 --headless --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugin-port=9222)
        }
    )

    @driver = Selenium::WebDriver.for :chrome, desired_capabilities: caps
    @driver.navigate.to "https://ur.rousesales.com/EquipmentListing/Classification/Compaction?page=#{@pageNumber}"

    try_get_result_list
    while !@webpage_loaded
      sleep 1.second
    end

    @vehicles_lis = @results_list.find_elements(:tag_name, "li")
    get_info
    puts '>>>> VEHICLES'
    puts @vehicles.inspect
  end

  def try_get_result_list
    @results_list = @driver.find_element(:id, "results-list")
    if @results_list
      @webpage_loaded = true
    end
  end

  def get_info
    @vehicles_lis.each do |li|
      divs = li.find_elements(:tag_name, "div")
      main_image = get_main_image(divs[0])
      title = get_title(divs[1])
      location = get_location(divs[1])
      price = get_price(divs[1])

      equipment_id = divs[4].attribute('id')
      quick_view_expanded = false

      # Open Quick View
      quick_view_btn = li.find_element(:class, "results-quick-link")
      @driver.execute_script("arguments[0].click();", quick_view_btn)

      while !quick_view_expanded
        sleep(1)
        is_expanded = divs[4].attribute('aria-expanded')
        if is_expanded
          quick_view_expanded = true
        end
      end

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
                         equipment_type: equipment_type,
                         category: category,
                         sub_category: sub_category,
                         details: details,
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

  def get_price(div)
    price = div.find_element(:tag_name, "h3").text
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