# salsify_rubocop

This gem provides shared configuration for RuboCop for Salsify applications/gems and some experimental cops.

[RuboCop](https://github.com/bbatsov/rubocop) is a static code analyzer that 
can enforce style conventions as well as identify common problems.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development, :test do
  gem 'salsify_rubocop', require: false
end  
```

Or to your gem's gemspec file:

```ruby
spec.add_development_dependency 'salsify_rubocop'
```

If you created your gem using 
[cookiecutter-salsify-gem](https://github.com/salsify/cookiecutter-salsify-gem)
then this dependency was added automatically.

Then execute:

    $ bundle install

It's best to ensure that you're starting from the latest release, so execute:

    $ bundle update salsify_rubocop

## Configuration

To use one of the shared RuboCop configurations from this gem, you must define
a `.rubocop.yml` file at the top-level directory in your project:

```yaml
inherit_gem:
  salsify_rubocop: conf/rubocop_rails.yml
```

Further customization of RuboCop for your local project may also be added to
this file.

### Available Configurations

- **rubocop_rails**: For Rails projects, this inherits from **rubocop**.
- **rubocop**: Assumes RSpec is used and requires 
  [rubocop-rspec](https://github.com/nevir/rubocop-rspec). This configuration
  is the default for gems. This inherits from **rubocop_without_rspec**.
- **rubocop_without_rspec**: Configuration without `rubocop-rspec`. This is 
  intended for gems that we may have forked and taken ownership of without
  converting tests from a different framework.
  
## Usage

Run `rubocop` for an entire project:

    $ bundle exec rubocop --format fu
    
See the `rubocop` command-line for additional options including auto-generating
configuration for existing offenses and auto-correction.

### Overcommit

Consider using [overcommit](https://github.com/brigade/overcommit) to 
automatically run `rubocop` on changed files before committing.

This is automatically added by 
[cookiecutter-salsify-gem](https://github.com/salsify/cookiecutter-salsify-gem/blob/master/%7B%7Bcookiecutter.repo_name%7D%7D/.overcommit.yml).

### CI

Consider running `rubocop` prior to running tests in CI for your project. 

TODO: add more info here.

## Versioning

This gem is versioned based on the MAJOR.MINOR version of `rubocop`. The first
release of the `salsify_rubocop` gem was v0.40.0.

The patch version for this gem does _not_ correspond to the patch version of 
`rubocop`. The patch version for this gem will change any time that one of its
configurations is modified _or_ its dependency on `rubocop` is changed to require
a different patch version.

This gem also includes a dependency on `rubocop-rspec` that will be updated to
the latest compatible version each time that the MAJOR.MINOR version of `rubocop` 
is updated.

## Change Process

This configuration is meant to represent the general opinion of Salsify's Ruby community around best practices for
writing readable Ruby code. As a result, changes to this configuration should go through a discussion phase in the
#rubocop-changes Slack channel to ensure the broader Salsify Ruby community is on board with the change. Non-Salsify
developers should file an issue via GitHub with proposed changes.

When enabling a cop we try to keep the following points in mind to avoid overburdening consumers:

* Does the cop support safe auto-correction? If not, do we expect a large number of offenses needing manual remediation?
* Does the cop help avoid bugs or is it merely stylistic?
* For stylistic cops, does the enforced style reflect that of Salsify developers?

### Updating RuboCop

Updating to a new minor version of `rubocop` may add new "pending" cops which are not enabled until the next major
version (see: [RuboCop Versioning](https://docs.rubocop.org/rubocop/versioning.html)). However, we may wish to eagerly
enable or explicitly disable newly introduced cops. Any such decisions around "pending" cops should go through the
change process described above.

When updating to a new major version or updating other dependencies that don't follow the same versioning pattern, we
should check if there are any newly enabled cops included in the update. Any new cops should go through a review process
in #rubocop-changes to ensure we truly want to enable the cop.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec salsify_rubocop` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/salsify/salsify_rubocop.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

