require 'nokogiri'
require 'open-uri'
require 'openssl'
require 'mechanize'

class HeavyVehiclesWorker

  def self.get_total_cars
    doc = Nokogiri::HTML(open('https://ur.rousesales.com/used-equipment-results', ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
    doc.xpath("//h3[@class='results-title']/span").first.content.gsub(/[(,)]/, '').to_i
  end

  def self.get_total_pages
    (get_total_cars / 25).ceil
  end

  def self.get_for_page(page)
    vehicles = []
    doc = Nokogiri::HTML(open("https://ur.rousesales.com/used-equipment-results?page=#{page}", ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
    vehicles_raw = doc.xpath("//ul[@id='results-list']/li")

    vehicles_raw.each do |vehicle_raw|
      vehicle_ur_id = get_vehicle_id(vehicle_raw)
      detail_doc = Nokogiri::HTML(open("https://ur.rousesales.com/Equipment/#{vehicle_ur_id}", ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE))
      vehicles << process_vehicle(detail_doc.inner_html, vehicle_ur_id)
    end
    vehicles
  end

  def self.get_vehicle_id(vehicle_raw)
    vehicle_id = vehicle_raw.xpath("//*[@class=\"results-drop-area\"]").first.parent.attr("id")
    vehicle_id
  end

  def self.process_vehicle(vehicle_raw, ur_id)
    vehicle_element = Nokogiri::HTML(vehicle_raw)
    basic_element = {
        title: vehicle_element.xpath("//h2[@class='detail-title']").text,
        source_id: vehicle_element.xpath('//a').first.attributes['href'].value.gsub(/.*\//, ''),
        price: vehicle_element.xpath("//h3[@class='font-weight-300 cost-size']").first.content.gsub(/\$|,| .*|\\n/, '').to_i,
        location: vehicle_element.xpath("//a[@class='detail-location']").first.content,
        main_image: vehicle_element.xpath("//img[@class='img-border']").first.attributes['src'].value
    }
    # vehicle = append_specs(basic_element, vehicle_element.css("ul.spec-list li"))
    vehicle = append_images(append_specs(basic_element, vehicle_element.css("ul.spec-list li")), vehicle_element.css("img.slider-tile"))
    vehicle
    puts vehicle.inspect
    sleep(10)
  end

  def self.append_images(obj, sliders)
    obj['tile-images'] = sliders.map { |img| img.attr("src") }
    obj
  end

  def self.append_specs(obj, specs_list)
    specs_names = ['manufacturer', 'class_code', 'year', 'meter', 'serial', 'equipment_id', 'description', 'equipment_type', 'category']
    total_count = specs_names.length
    specs_list.each_with_index do |spec, index|
      if total_count > 0
        obj[specs_names[index]] = spec.css("span").text.strip
        # puts "#{specs_names[index]}: #{spec.css("span").text.strip}"
        # specs.push(spec.css("span").text.strip)
        total_count -= 1
      end
    end
    obj
  end
end