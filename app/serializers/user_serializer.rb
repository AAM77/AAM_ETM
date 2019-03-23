class UserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :provider, :first_name,
             :last_name, :telephone_num, :address,
             :email, :username, :password_digest,
             :total_points
end
