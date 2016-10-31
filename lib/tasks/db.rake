namespace :db do
  desc 'Load the seed data from SEED_FILENAME'
  task :seed_from_file => 'db:abort_if_pending_migrations' do
    seed_file = File.join(Rails.root, 'db', ENV['SEED_FILENAME'])
    load(seed_file) if File.exist?(seed_file)
  end
end
