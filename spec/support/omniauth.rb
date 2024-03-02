OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                     provider: 'google_oauth2',
                                                                     uid: '123545',
                                                                     info: {
                                                                       email: 'testuser@test.com',
                                                                       name: 'Test User',
                                                                       image: 'https://gravatar.com/avatar/dea2247d0728a87dc1cf4028109e862e?s=400&d=robohash&r=x'
                                                                     },
                                                                     credentials: { # This is a sample credentials hash, you can find this in `request.env["omniauth.auth"]["credentials"]`
                                                                       token: 'asdf1234',
                                                                       refresh_token: 'qwerty1234',
                                                                       expires_at: Time.now + 1.week,
                                                                       expires: true
                                                                     }
                                                                   })
