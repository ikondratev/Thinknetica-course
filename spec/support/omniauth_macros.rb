module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      'provider' => 'twitter',
      'uid' => '12345',
      'user_info' => {
        'name' => 'mockuser_twitter',
        'image' => 'mock_user_twitter_url'
      },
      'credentials' => {
        'token' => 'mock_token_twitter',
        'secret' => 'mock_secret_twitter'
      }
    )

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      'provider' => 'facebook',
      'uid' => '54321',
      'info' => {
        'name' => 'mockuser_facebook',
        'image' => 'mock_user_facebook_url',
        'email' => 'mockuser_facebook@example.com'
      },
      'credentials' => {
        'token' => 'mock_token_facebook',
        'secret' => 'mock_secret_facebook'
      }
    )

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      'provider' => 'github',
      'uid' => '54321',
      'info' => {
        'name' => 'mockuser_github',
        'image' => 'mock_user_github_url',
        'email' => 'mockuser_github@example.com'
      },
      'credentials' => {
        'token' => 'mock_token_github',
        'secret' => 'mock_secret_github'
      }
    )
  end
end
