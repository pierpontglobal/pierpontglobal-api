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
      vehicles << process_vehicle(vehicle_raw.inner_html)
    end
    vehicles
  end

  def self.process_vehicle(vehicle_raw)
    vehicle_element = Nokogiri::HTML(vehicle_raw)
    {
      title: vehicle_element.xpath('//h4').first.content,
      source_id: vehicle_element.xpath('//a').first.attributes['href'].value.gsub(/.*\//, ''),
      price: vehicle_element.xpath('//h3').first.content.gsub(/\$|,| .*|\\n/, '').to_i,
      location: vehicle_element.xpath("//span[@class='location-content']").first.content,
      main_image: vehicle_element.xpath("//img").first.attributes['src'].value
    }
  end
end