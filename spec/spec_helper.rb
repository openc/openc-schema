require 'json-schema'

date_format_validator = -> value {
  begin
    Date.strptime(value, '%Y-%m-%d')
  rescue ArgumentError
    raise JSON::Schema::CustomFormatError.new('must be of format yyyy-mm-dd')
  end
}

JSON::Validator.register_format_validator('date', date_format_validator)

