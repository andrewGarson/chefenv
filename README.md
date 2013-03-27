# Chefenv

Manages multiple chef server/organization environments

## Installation

Add this line to your application's Gemfile:

    gem 'chefenv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chefenv

## Usage

Execute:

    $ chefenv init

This will ensure that you have a ~/chef directory.

Create a directory under ~/chef for each of your environments.
Put your knife.rb, .pem and any other files you need for that organization
under that folder. For example, for my hosted chef organization, I create
~/chef/hosted and put my knife.rb and .pem files in there. Additionally, this is
a reasonable place to put secret key files.

Once you have at least one folder created under ~/chef, you can

    $ chefenv list

or

    $ chefenv use ENVNAME

## Future Work

1. Allow using a different directory than ~/chef
1. Add tasks for creating/destroying organizations

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Author

Author:: Andrew Garson (<andrew.garson@gmail.com>)
