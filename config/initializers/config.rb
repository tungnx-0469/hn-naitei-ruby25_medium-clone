Config.setup do |config|
  # Name of the constant exposing loaded settings
  config.const_name = "Settings"

  # Ability to remove elements of the array set in earlier loaded settings file. For example value: '--'.
  #
  # config.knockout_prefix = nil

  # Overwrite an existing value when merging a `nil` value.
  # When set to `false`, the existing value is retained after merge.
  #
  # config.merge_nil_values = true

  # Overwrite arrays found in previously loaded settings file. When set to `false`, arrays will be merged.
  #
  # config.overwrite_arrays = true

  # Defines current environment, affecting which settings file will be loaded.
  # Default: `Rails.env`
  #
  # config.environment = ENV.fetch('ENVIRONMENT', :development)

  # Load environment variables from the `ENV` object and override any settings defined in files.
  #
  # config.use_env = false

  # Define ENV variable prefix deciding which variables to load into config.
  #
  # Reading variables from ENV is case-sensitive. If you define lowercase value below, ensure your ENV variables are
  # prefixed in the same way.
  #
  # When not set it defaults to `config.const_name`.
  #
  config.env_prefix = "SETTINGS"

  # What string to use as level separator for settings loaded from ENV variables. Default value of '.' works well
  # with Heroku, but you might want to change it for example for '__' to easy override settings from command line, where
  # using dots in variable names might not be allowed (eg. Bash).
  #
  # config.env_separator = '.'

  # Ability to process variables names:
  #   * nil  - no change
  #   * :downcase - convert to lower case
  #
  # config.env_converter = :downcase

  # Parse numeric values as integers instead of strings.
  #
  # config.env_parse_values = true

  # Validate presence and type of specific config values. Check https://github.com/dry-rb/dry-validation for details.
  #
  # config.schema do
  #   required(:name).filled
  #   required(:age).maybe(:int?)
  #   required(:email).filled(format?: EMAIL_REGEX)
  # end

  # Evaluate ERB in YAML config files at load time.
  #
  # config.evaluate_erb_in_yaml = true

  # Name of directory and file to store config keys
  #
  # config.file_name = 'settings'
  # config.dir_name = 'settings'

  # Load extra sources from a path. These can be file paths (strings),
  # hashes, or custom source objects that respond to 'load'
  #
  # config.extra_sources = [
  #   'path/to/extra_source.yml',          # String: loads extra_source.yml
  #   { api_key: ENV['API_KEY'] },         # Hash: direct hash source
  #   MyCustomSource.new,                  # Custom source object
  # ]
end
