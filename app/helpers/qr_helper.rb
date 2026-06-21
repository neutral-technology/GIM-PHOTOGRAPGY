module QrHelper
  require "rqrcode"

  def qr_code_for(url)
    qrcode = RQRCode::QRCode.new(url)
    png = qrcode.as_png(
      size: 300,
      border_modules: 2
    )
    "data:image/png;base64,#{Base64.strict_encode64(png.to_s)}"
  end
end