module LoginHelper
  def login
    api_key = create(:api_key)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(api_key.access_token)
  end
end
