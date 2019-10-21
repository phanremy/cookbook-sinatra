require 'nokogiri'
require 'open-uri'

class Parsing
  def initialize(url, difficulty)
    @url = url
  end

  doc = Nokogiri::HTML(open(@url, "Accept-Language" => "en").read)
  m = doc.search("h1").text.match /(?<title>.*)[[:space:]]\((?<year>\d{4})\)/

  title = m[:title]
  year = m[:year].to_i

  def scrape
  end
end
