namespace :db do 
  desc "Adminを足す（必ずパスワードとメールアドレスを変更すること！！"
  task populate: :environment do
    admin = User.create!(name: "Admin",
                         email: "desper1jp+admin@gmail.com",
                         password: "hogehoge",
                         password_confirmation: "hogehoge",
                         admin: true)
  end
end
