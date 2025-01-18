namespace :db do
  namespace :fixtures do
    desc "Writes fixtures from the database to the filesystem"
    task dump: :environment do
      Rails.application.eager_load!
      models = defined?(ApplicationRecord) ? ApplicationRecord.descendants : ActiveRecord::Base.descendants
      models.each do |model|
        model_name = model.name.pluralize.underscore
        File.open("#{Rails.root}/test/fixtures/#{model_name}.yml", "w") do |file|
          file.write model.all.to_a.map(&:attributes).to_yaml
        end
      end
    end
  end
end
