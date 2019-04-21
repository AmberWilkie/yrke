module SpreadsheetReader
  require 'google/apis/sheets_v4'

  RANGE = 'Sheet1!A1:D5'.freeze

  def read
    url = "https://sheets.googleapis.com/v4/spreadsheets/#{ENV['SPREADSHEET_ID']}/values/#{RANGE}?majorDimension=ROWS"
    request = HTTParty.get(url, headers: { 'Authorization' => "Bearer #{ENV['ACCESS_TOKEN']}" })
  end

  def write


    service = Google::Apis::SheetsV4::SheetsService.new

    service.authorization = ENV['ACCESS_TOKEN']

    request_body = Google::Apis::SheetsV4::ValueRange.new
    request_body.major_dimension = 'ROWS'
    request_body.range = RANGE
    request_body.values = [
      ['Value one', 'value two', 'value three'],
      ['Value six', 'value seven', 'value eight', 'value nine'],
    ]


    response = service.append_spreadsheet_value(ENV['SPREADSHEET_ID'], RANGE, request_body,
                                                value_input_option: 'USER_ENTERED',
                                                insert_data_option: 'INSERT_ROWS',
                                                include_values_in_response: true)

    puts response.to_json
  end

end
