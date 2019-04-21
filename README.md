# Yrke, the Google Spreadsheets job search helper

## The jist
Discover and review job posting from big site (tbd) and organize them using Google sheets. Take notes, color things in etc.
Yrke (Swedish for "work") will post new job listings to your sheet, ignoring those you've already seen.

Check your spreadsheet in the morning for new postings and stop visiting all the jobs sites.

## To do
- ~~Set up OAuth (for me personally)~~
- ~~Write to spreadsheet~~
- Get job listings
- Parse and format job listings
- Filter job listings based on user preference and what is already in the user's spreadsheet
- Post new job listings to user's sheet

## Notes to be translated to something more legible later

1. First get an authorisation URI for the user:

```ruby 
client_secrets = Google::APIClient::ClientSecrets.load
auth_client = client_secrets.to_authorization
auth_client.update!(
  :scope => 'https://www.googleapis.com/auth/drive.metadata.readonly',
  :redirect_uri => 'http://localhost:4000/oauth_callback',
  additional_parameters: {"access_type" => "offline"}
)
auth_uri = auth_client.authorization_uri.to_s
```


2. Send the user to that URI. They have to accept.
3. The response hits your /callback with these params:

```ruby
=> <ActionController::Parameters {"code"=>'response-code', "scope"=>"https://www.googleapis.com/auth/drive.metadata.readonly", "controller"=>"auth", "action"=>"callback"} permitted: false>
```

4. Now you can obtain an access token for that user:
````ruby
auth_client.code = 'response-code'
auth_client.fetch_access_token!
 => {"access_token"=>'access-token', "expires_in"=>3600, "refresh_token"=>'refresh-token', "scope"=>"https://www.googleapis.com/auth/drive.metadata.readonly", "token_type"=>"Bearer"}
````

5. Use that access_token to sign requests for that user’s data:
```ruby
url = "https://sheets.googleapis.com/v4/spreadsheets/<spreadsheet-id>/values/Sheet1!A1:D3?majorDimension=COLUMNS"
request = HTTParty.get(url, headers: {'Authorization' => "Bearer <access-token>"})
```

Your access token must have been requested with the right scope for the request you are making.

When it works, it looks like this:
```ruby
:036 > request = HTTParty.get(url, headers: {'Authorization' => "Bearer <access-token>"})
 => #<HTTParty::Response:0x7fcf170d1f18 parsed_response={"range"=>"Sheet1!A1:D3", "majorDimension"=>"ROWS", "values"=>[["Company", "Title", "Link", "Notes"], ["Tech Warehouse", "Slave", "http://whatever.com", "I don't want to work here."]]}, @response=#<Net::HTTPOK 200 OK readbody=true>, @headers={"content-type"=>["application/json; charset=UTF-8"], "vary"=>["X-Origin", "Referer", "Origin,Accept-Encoding"], "date"=>["Sat, 20 Apr 2019 07:13:52 GMT"], "server"=>["ESF"], "cache-control"=>["private"], "x-xss-protection"=>["1; mode=block"], "x-frame-options"=>["SAMEORIGIN"], "alt-svc"=>["quic=\":443\"; ma=2592000; v=\"46,44,43,39\""], "accept-ranges"=>["none"], "connection"=>["close"]}>
```


Write to a spreadsheet:

Request body:
```ruby
{
  "majorDimension": "ROWS",
  "range": "Sheet1!A1:D5",
  "values": [
    [
      "Item",
      "Cost",
      "Stocked",
      "Ship Date"
    ],
    [
      "Wheel",
      "$20.50",
      "4",
      "3/1/2016"
    ],
    [
      "Door",
      "$15",
      "2",
      "3/15/2016"
    ],
    [
      "Engine",
      "$100",
      "1",
      "30/20/2016"
    ]
  ]
}
```


Response:
```ruby

{
  "spreadsheetId": <redacted>,
  "tableRange": "Sheet1!A1:E2",
  "updates": {
    "spreadsheetId": <redacted>,
    "updatedRange": "Sheet1!A3:D6",
    "updatedRows": 4,
    "updatedColumns": 4,
    "updatedCells": 16,
    "updatedData": {
      "range": "Sheet1!A3:D6",
      "majorDimension": "ROWS",
      "values": [
        [
          "Item",
          "Cost",
          "Stocked",
          "Ship Date"
        ],
        [
          "Wheel",
          "$20.50",
          "4",
          "3/1/2016"
        ],
        [
          "Door",
          "$15",
          "2",
          "3/15/2016"
        ],
        [
          "Engine",
          "$100",
          "1",
          "30/20/2016"
        ]
      ]
    }
  }
}
```

Ruby docs reference for Google Sheets Service (very helpful for understanding how to send query params)
https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/SheetsV4/SheetsService



