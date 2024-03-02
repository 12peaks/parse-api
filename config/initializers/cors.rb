Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    client_url = ENV['CLIENT_URL'] || 'http://localhost:3000'
    origins 'localhost:3000', client_url

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             credentials: true
  end
end

