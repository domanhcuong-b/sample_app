class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  process resize_to_limit: Settings.micropost.LIMIT_IMG_SIZE

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_allowlist
    Settings.micropost.IMG_EXTENSION_ALLOW
  end

  def size_range
    0..Settings.micropost.PICTURE_MAX_SIZE.megabytes
  end
end
