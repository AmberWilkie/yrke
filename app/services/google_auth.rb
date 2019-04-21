require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'

module GoogleAuth
  def self.authorization_link
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: 'https://www.googleapis.com/auth/spreadsheets',
      redirect_uri: 'http://localhost:4000/oauth_callback',
      additional_parameters: { "access_type" => "offline" }
    )
    auth_uri = auth_client.authorization_uri.to_s
  end

  def self.new_access_token
    url = URI("https://accounts.google.com/o/oauth2/token")
    response = Net::HTTP.post_form(url, params)
    JSON.parse(response.body)['access_token']
  end

  def self.params
    { 'refresh_token' => ENV['REFRESH_TOKEN'],
      'client_id' => ENV['CLIENT_ID'],
      'client_secret' => ENV['CLIENT_SECRET'],
      'grant_type' => 'refresh_token' }
  end
end
