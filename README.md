# omniauth-vk
Authorization OmniAuth strategy for [vk.com](https://vk.com). Current [api version](https://vk.com/dev/versions) is 5.42.
More details [here](https://vk.com/dev)
### Installation
Add to your `Gemfile`
```ruby
gem 'omniauth-vk'
```
Then `bundle install`
### Basic usage
> You can use RVM environment variables. [Read more](https://rvm.io/workflow/projects#project-file-versionsconf)

Add the middleware to a Rails app in `config/initializers/omniauth.rb`:
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vk, ENV['VK_KEY'], ENV['VK_SECRET']
end
```
or in other rack-based applications
```ruby
use OmniAuth::Builder do
  provider :vk, ENV['VK_KEY'], ENV['VK_SECRET']
end
```
### Setup with Devise
Add in  `config/initializers/devise.rb`:
```ruby
config.omniauth :vk, ENV['VK_KEY'],
                     ENV['VK_SECRET']
```
### Options
You can use [auth params](https://vk.com/dev/auth_sites)
 ```ruby
config.omniauth :vk, ENV['VK_KEY'],
                     ENV['VK_SECRET'],
                     redirect_uri: '/auth/vk',
                     # Available values: page - default, popup, mobile - default for mobile devices
                     display: 'popup',
                     # List of Available Settings of Access Permissions https://vk.com/dev/permissions
                     scope: 'email, friends',
                     v: 3.42
```
and [api request parameters](https://vk.com/dev/api_requests)
 ```ruby
config.omniauth :vk, ENV['VK_KEY'],
                     ENV['VK_SECRET'],
                     # Available values: ru, ua, be, en, es, fi, de, it
                     lang 'en'
                     https: 1,
                     test_mode: 1
```
### Default Auth Hash
```ruby
{ "provider"=>"vk",
  "uid"=>"1",
  "info"=> {
    "name"=>"Павел Дуров",
    "first_name"=>"Павел",
    "last_name"=>"Дуров",
    "user_id"=>"1"
  },
  "credentials"=> {
    "token"=> "187041a618229fdaf16613e96e1caabc1e86e46bbfad228de41520e63fe45873684c365a14417289599f3",
    "expires_at"=>1381826003,
    "expires"=>true
  },
  "extra"=> {
    "raw_info"=> {
      "id"=>1,
      "first_name"=>"Павел",
      "last_name"=>"Дуров" }
    }
}
```
### Other available fields
List of all available fields [here](https://vk.com/dev/users.get)
 ```ruby
config.omniauth :vk, ENV['VK_KEY'],
                     ENV['VK_SECRET'],
                     scope: 'email' # email doesn't provided by default
                     fields: 'sex, bdate, city, country'
```
#### Hash example
```ruby
{ "provider"=>"vk",
  "uid"=>"1",
  "info"=> {
    "email"=>"",
    "name"=>"Павел Дуров",
    "first_name"=>"Павел",
    "last_name"=>"Дуров",
    "user_id"=>"1"
  },
  "credentials"=> {
    "token"=> "187041a618229fdaf16613e96e1caabc1e86e46bbfad228de41520e63fe45873684c365a14417289599f3",
    "expires_at"=>1381826003,
    "expires"=>true
  },
  "extra"=> {
    "raw_info"=> {
      "first_name"=>"Павел",
      "id"=>1,
      "last_name"=>"Дуров"
      "sex"=>2,
      "bdate"=>"10.10.1984",
      "city"=>"2",
      "country"=>"1",}
    }
}
```
## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/Sharevari-Inc/omniauth-vk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.
## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
