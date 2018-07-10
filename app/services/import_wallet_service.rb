require 'uri'
require 'net/http'

require 'formdata'

class ImportWalletService
  def import(card_data, access_token)
    # file = File.new("mycard.card", "w+")
    # file.binmode
    # file.write card_data.body.to_blob
    # file.close
    save_path = Rails.root.join("public/mycard.card")

binding.pry
    formData = FormData.new

    File.open(save_path, 'wb') do |f|
        binding.pry
      f.write card_data.body.to_blob
    end

    formData.append('card', File.new(save_path, 'r'), {
        :content_type => 'application/octet-stream',
        :filename => 'mycard.card'
      })
    # formData.append('card', file)
    

    binding.pry
    url = URI(USER_API_BASE_URL+"/wallet/import?access_token="+access_token)
    header = {"Content-Type": "multipart/form-data; boundary=#{formData.instance_variable_get('@boundary')}"}
    # binding.pry
    # post_body = []
    # # Add the file Data
    # post_body << "--#{boundary}\r\n"
    # post_body << "Content-Disposition: form-data; name=\"card\"; filename=\"#{File.basename(file)}\"\r\n"
    # post_body << "Content-Type: application/octet-stream\r\n\r\n"
    # post_body << File.open('mycard.card','rb').read
    binding.pry

    # Create the HTTP objects
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Post.new(url.request_uri, header)
    request["withCredentials"] = 'true'
    request.content_type = formData.content_type
    request.content_length = formData.size
    request.body_stream = formData

    binding.pry
    response = http.request(request)
    binding.pry

    # binding.pry
    # # request["Postman-Token"] = '5e868c0b-803f-471e-9fb4-0244dd2c7430'4

    # binding.pry
    # request = Net::HTTP::Post.new(url)
    # request["content-type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
    # request["Content-Type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
    # request["withCredentials"] = 'true'
    # request["Cache-Control"] = 'no-cache'
    # request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"card\"; filename=\"#{File.basename(file)}\"\r\nContent-Type: application/octet-stream\r\n\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
    # # request.body = formData
    # binding.pry
    # # request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"card\"; filename=\"res.bin\"\r\nContent-Type: application/octet-stream\r\n\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"

    # response = http.request(request)
    # binding.pry
    # puts response.read_body
    # header = 
    # request = Net::HTTP::Post.new(url)
    # request["Content-Type"] = 'multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW'
    # request["withCredentials"] = 'true'
    # request["Cache-Control"] = 'no-cache'
    # request.body = "------WebKitFormBoundary7MA4YWxkTrZu0gW\r\nContent-Disposition: form-data; name=\"card\"; filename=\"#{File.basename(file)}\"\r\nContent-Type: application/octet-stream\r\n\r\n\r\n------WebKitFormBoundary7MA4YWxkTrZu0gW--"
    # binding.pry
    # response = http.request(request)
    # binding.pry
    response
  end
end