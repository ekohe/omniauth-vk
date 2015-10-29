# Omniauth::Vk
Authorization OmniAuth strategy for [vk.com](https://vk.com). Current api [version](https://vk.com/dev/versions) is 5.37.
More details [here](https://vk.com/dev)
## Installation
Add to your `Gemfile`:
```ruby
gem 'omniauth-vk'
```
Then `bundle install`.
## Usage


`OmniAuth::Strategies::Vk` is simply a Rack middleware. Read the OmniAuth OAuth2 docs for detailed instructions: https://github.com/intridea/omniauth-oauth2.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vk, ENV['VK_KEY'], ENV['VK_SECRET']
end
```
or in rack applications
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
You can also use [api request parameters](https://vk.com/dev/api_requests) and [auth params](https://vk.com/dev/auth_sites)
 ```ruby
config.omniauth :vk, ENV['VK_KEY'],
                     ENV['VK_SECRET'],
                     scope: 'email',
                     display: 'popup',
                     v: 5.37,
                     https: 1
```
#### Controller
```ruby
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def vk
    data = request.env['omniauth.auth']
    current_user && current_user.update_provider(data) && redirect_to(edit_user_registration_path) && return
    user = User.from_omniauth(data)
    user.persisted? ? sign_in_and_redirect(user) : redirect_to(new_user_registration_path)
  end
end
```
#### Model
```ruby
class User
  include GlobalID::Identification

  devise :omniauthable, omniauth_providers: [:vk]

  def update_provider(data)
    field = "#{data['provider']}_uid"
    self[field] != data['uid'] && set(field => data['uid'])
    save
  end

  def self.from_omniauth(data)
    where("#{data['provider']}_uid": data['uid']).first_or_create do |user|
      user.email = data['info']['email']
      user.password = Devise.friendly_token
      user.skip_confirmation!
    end
  end
```
Create migration
```ruby
class AddProviderUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vk_uid, :integer
  end
end
```
for ActiverRecord ORM or Add
```
field :vk_uid, type: :integer
```
for Mongoid
## Default Auth Hash
```ruby
{"provider"=>"vk",
 "uid"=>"1",
 "info"=>
  {"name"=>"Павел Дуров",
   "first_name"=>"Павел",
   "last_name"=>"Дуров"}
 "credentials"=>
  {"token"=>
    "187041a618229fdaf16613e96e1caabc1e86e46bbfad228de41520e63fe45873684c365a14417289599f3",
   "expires_at"=>1381826003,
   "expires"=>true},
 "extra"=>
  {"raw_info"=>
    {"id"=>1,
     "first_name"=>"Павел",
     "last_name"=>"Дуров"}}}
```
For get other available [fields](https://vk.com/dev/users.get) add
 ```ruby
config.omniauth :vk, ENV['VK_KEY'],
                     ENV['VK_SECRET'],
                     scope: 'email photos video audio', # List of Available Settings of Access Permissions https://vk.com/dev/permissions
                     fields: 'sex, bdate, city, country, photo_50, photo_100,
                             photo_200_orig, photo_200, photo_400_orig, photo_max,
                             photo_max_orig, photo_id, online, online_mobile, domain,
                             has_mobile, contacts, connections, site, education,
                             universities, schools, can_post, can_see_all_posts,
                             can_see_audio, can_write_private_message, status, last_seen,
                             common_count, relation, relatives, counters, screen_name,
                             maiden_name, timezone, occupation,activities, interests, music,
                             movies, tv, books, games, about, quotes, personal,
                             friend_status, military, career'
```
```ruby
{"provider"=>"vk",
 "uid"=>"1",
 "info"=>
  {"name"=>"Павел Дуров",
   "first_name"=>"Павел",
   "last_name"=>"Дуров",
   "email"=>"", # scopes
   ... etc
  }
 "credentials"=>
  {"token"=>
    "187041a618229fdaf16613e96e1caabc1e86e46bbfad228de41520e63fe45873684c365a14417289599f3",
   "expires_at"=>1381826003,
   "expires"=>true
  },
 "extra"=>
  {"raw_info"=>
    {"id"=>1,
     "first_name"=>"Павел",
     "last_name"=>"Дуров",
     "sex"=>"1", # fields
     ...etc
    }
  }
}
```
## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/Sharevari-Inc/omniauth-vk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.
## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
