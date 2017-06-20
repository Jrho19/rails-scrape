class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  class Entry
    def initialize(title, url, rent, address)
      @title = title
      @url = url
      @rent = rent
      @address = address
    end
    attr_reader :title, :url, :rent, :address
  end

  def scrape_reddit
    require 'open-uri'
    site = "https://miami.craigslist.org/search/swp?min_bedrooms=3&max_bedrooms=3&min_bathrooms=2&max_bathrooms=2&availabilityMode=0"
    doc = Nokogiri::HTML(open(site))
    entries = doc.css('.result-row')
    @entries_array = []
    entries.each do |entry|
     title = entry.css('p.result-info>a').text
     url = entry.css('p.result-info>a')[0]['href']
     rent = entry.css('.result-meta').css('.result-price').text
     address = entry.css('span.result-hood').text
     @entries_array << Entry.new(title, url, rent, address)
    end
    render template: 'scrape_reddit'
  end
end
