require 'uri'
require 'net/http'
require 'securerandom'
require 'formdata'

class ImportWalletServiceMulti
  def import(card_data, access_token)
    response = Object.new

    uniq_file_name = SecureRandom.hex + '.card'
    save_path = Rails.root.join("public/" + uniq_file_name)
    
    File.open(save_path, 'wb') do |f|
      f.write card_data.body
    end

    formData = FormData.new    
    formData.append('card', File.new(save_path, 'r'), {
        :content_type => 'application/octet-stream',
        :filename => uniq_file_name
      })

    url = URI(USER_API_BASE_URL+"/wallet/import?access_token="+access_token)
    http = Net::HTTP.new(url.host, url.port)
    header = {"Content-Type" => "multipart/form-data; boundary=#{formData.instance_variable_get('@boundary')}"}
    
    request = Net::HTTP::Post.new(url.request_uri, header) 
    
    request["withCredentials"] = 'true'
    request.content_type = formData.content_type
    request.content_length = formData.size
    request.body_stream = formData
    
    i = 0
    while i < 3
        puts "#{i} Attempt Started -->" 
        begin
            response = http.request(request)
            break
        rescue Exception => e
            puts e
            i = i + 1
        ensure
            File.delete(save_path) if File.exist?(save_path)
        end
    end
    response
  end

  def logout
    url = URI(GITHUB_SIGNOUT_URL)
    header = {"Referer" => "http://localhost:4200"}
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url.request_uri, header)
    http.request(request)
  end
end