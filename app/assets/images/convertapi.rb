file = params[:exam][:image].original_filename

if FastImage.type(file) == :tif

  ConvertApi.configure do |config|
    config.api_secret = ENV['CONVERT_API_SECRET']
  end

  result = ConvertApi.convert('jpg', File: file, ImageHeight: '1424', ImageWidth: '1100')
  @exam.remote_image_url = result.files.first.url
end
