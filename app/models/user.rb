# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  deleted_flg            :boolean          default(FALSE), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  phone                  :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations

  validates :name, presence: true, length: { in: 2..20 }
  validates :email, presence: true
  validates :phone, presence: true

  def update_password(params, *options)
    if params[:password].blank?
      params.delete(:password)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  scope :search_information, lambda { |keyword|
    where('name LIKE :keyword OR id LIKE :keyword OR email LIKE :keyword OR phone LIKE :keyword', keyword: "%#{keyword}%")
  }

  # 退会フラグ
  extend SwitchFlg

  # ゲストログイン
  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|  # ゲストログイン用
      user.name = 'guestuser'
      user.phone = '00000000000'
      user.password = 'password'
      user.password_confirmation = 'password'
    end
  end
end
