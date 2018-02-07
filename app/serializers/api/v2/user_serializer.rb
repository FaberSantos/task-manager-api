class Api::V2::UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :password, :auth_token, :created_at, :updated_at
end
