class RowBuilder
  def initialize(company: 'Not available', title: 'Not available', location: 'Not available', link: 'Not available', description: 'Not available')
    @company = company
    @title = title
    @location = location
    @link = link
    @description = description
  end

  def build
    [company, title, location, link, description]
  end

  private

  attr_accessor :company, :title, :location, :link, :description
end
