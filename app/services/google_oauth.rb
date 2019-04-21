require 'google/apis/drive_v2'
require 'google/api_client/client_secrets'

module GoogleOAuth
  def self.authorize
    client_secrets = Google::APIClient::ClientSecrets.load
    auth_client = client_secrets.to_authorization
    auth_client.update!(
      scope: 'https://www.googleapis.com/auth/spreadsheets',
      redirect_uri: 'http://localhost:4000/oauth_callback'
    )
    auth_uri = auth_client.authorization_uri.to_s
  end
end
