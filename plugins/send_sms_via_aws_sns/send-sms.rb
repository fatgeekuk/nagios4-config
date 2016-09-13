=begin

  This script sends SMS messages to one or more telephone numbers.

  invoke it via the included shell script wrapper like so :-

  send-sms '<who from>' '< comma delim list of international phone numbers >' '<message>'

  International numbers start with +xx where xx is the country code (44 for the UK)
  and then continue with the local mobile number with the leading 0 removed.

  So, 07985236241 becomes +447985236241.

  Authentication.

  This is accomplished by putting a settings file in the ~/.aws directory
  of the running user called "credentials" that contains values for the
  key and secret as follows

  ---------- beginning of gile ----------
  [default]
  aws_access_key_id = XXXXXXXXXXXXX
  aws_secret_access_key = YYYYYYYYYYYYYYYYY
  ------------- end of file -------------

=end

require 'aws-sdk'

region = 'us-east-1'

sender, numbers, text_message = ARGV

sns = Aws::SNS::Client.new(region: region)

numbers.split(',').each do |number|
  message = {
    phone_number: number,
    message: text_message,
    message_attributes: {
      "AWS.SNS.SMS.SenderID" => {
        data_type: "String",
        string_value: sender
      }
    }
  }
  sns.publish(message)
end
