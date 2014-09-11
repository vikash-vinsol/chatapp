class Sms
  require 'net/http'
  require 'uri'

  INFOBIP_CREDENTIALS = YAML.load_file("#{Rails.root}/config/sms_delivery.yml")

  SMS_RESPONSES = { 
    '0' => 'Request was successful',
    '-1' => "Error in processing the request",
    '-2' => "Not enough credits on a specific account",
    '-3' => "Targeted network is not covered on specific acount",
    '-5' => "Username or password is invalid",
    '-6' => "Destination address is missing in the request",
    '-10' => "Username is missing in the request",
    '-11' => "Password is missing in the request",
    '-13' => "Number is not recognized by Infobip platform",
    '-22' => "Incorrect XML format, caused by syntax error",
    '-23' => "General error, reasons may vary",
    '-26' => "General API error, reasons may vary",
    '-27' => "Invalid scheduling parametar",
    '-28' => "Invalid PushURL in the request",
    '-30' => "Invalid APPID in the request",
    '-33' => "Duplicated MessageID in the request",
    '-34' => "Sender name is not allowed",
    '-99' => "Error in processing request, reasons may vary"
  }
  
  def self.deliver(gsm, sms_text)
    return false if gsm.blank?
    response = ''
    status = ''
    if !INFOBIP_CREDENTIALS || !INFOBIP_CREDENTIALS
      Rails.logger.info "Credentials are not present"
    else
      # get the url that we need to post to
      url = URI.parse('http://api.infobip.com/api/v3/sendsms/plain')
      # build the params string

      post_args1 = { user: INFOBIP_CREDENTIALS['user'], password: INFOBIP_CREDENTIALS['password'], sender: INFOBIP_CREDENTIALS['sender'], GSM: gsm, SMSText: sms_text }
      begin
        response = Net::HTTP.post_form(url, post_args1)
        status = Hash.from_xml(response.body)['results']['result']['status']
        Rails.logger.info "SMS TEXT :- #{sms_text}"
        Rails.logger.info "Response :- #{SMS_RESPONSES[status]}"
        Rails.logger.info "Destination :- #{gsm}"
      rescue Exception => e
        Rails.logger.info "Request could not be completed #{e}"
      end
    end
    Rails.logger.info "#{Time.zone.now}"
    response.blank? ? false : (status == '0')
  end
end
