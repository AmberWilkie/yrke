module LinkedinReader
  require 'open-uri'

  def get_jobs
    search_url = "https://www.linkedin.com/jobs/search/?distance=5&f_TPR=r604800&keywords=ruby&location=Philadelphia%2C%20Pennsylvania&locationId=PLACES.us.3-3-0-51-1"
    page = Nokogiri::HTML(open(search_url))
    jobs = page.css('li.job-result-card')

    # format job listings for adding to spreadsheet
    jobs.map do |job|
      title, location = job.css('span').map(&:text)
      link = job.css('a').first['href']
      company = job.css('a')[1].text
      description = company_description(link)
      RowBuilder.new(company: company, title: title, location: location, link: link, description: description).build
    end
  end

  def company_description(link)
    job_link = Nokogiri::HTML(link))
    job_link.css('div.description__text').text
  end
end
