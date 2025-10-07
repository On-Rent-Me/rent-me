class UserCodesController < ApplicationController
  def index
    @user_codes = Current.user.user_codes.order(created_at: :desc)
  end

  def new
    @user_codes = Current.user.user_codes.order(created_at: :desc)
  end

  def create
    require 'rqrcode'

    url = root_url
    qr = RQRCode::QRCode.new(url)

    @user_code = Current.user.user_codes.create!(
      url: url,
      qr_code_data: qr.as_svg(module_size: 6)
    )

    redirect_to user_code_path(@user_code), notice: "QR Code generated successfully!"
  end

  def show
    @user_code = Current.user.user_codes.find(params[:id])
  end
end
