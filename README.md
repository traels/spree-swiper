SpreeSwiper
===========

Allows for checkout using AppNinjas swiper solution, together with a Authorize.net account.
Still a bit experimental :)

Installation
------------

Add spree_swiper to your Gemfile:

```ruby
gem 'spree_swiper'
```

Bundle your dependencies:

```shell
bundle
```

Setup your Authorize access eg. in production.rb:
```ruby
AUTHORIZE_NET_API_ID = "123"
AUTHORIZE_NET_API_KEY = "456"
```

Copyright (c) 2013 Traels, released under the New BSD License
