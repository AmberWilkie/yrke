module LinkedinReader
  require 'open-uri'

  def get_jobs
    ruby_search = "https://www.linkedin.com/jobs/search/?distance=5&f_TPR=r604800&keywords=ruby&location=Philadelphia%2C%20Pennsylvania&locationId=PLACES.us.3-3-0-51-1&redirect=false&position=1&pageNum=0&f_TP=1"
    react_search = "https://www.linkedin.com/jobs/search?keywords=React.js&location=Philadelphia%20County%2C%20PA&trk=guest_job_search_jobs-search-bar_search-submit&redirect=false&position=1&pageNum=0&f_TP=1"
    ruby_page = Nokogiri::HTML(open(ruby_search))
    react_page = Nokogiri::HTML(open(react_search))
    jobs = ruby_page.css('li.job-result-card') + react_page.css('li.job-result-card')

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
