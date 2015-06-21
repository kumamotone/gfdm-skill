namespace :db do 
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Admin User",
                         email: "admin@admin.com",
                         password: "mimi_nary_admin",
                         password_confirmation: "mimi_nary_admin",
                         admin: true)
  end
end
