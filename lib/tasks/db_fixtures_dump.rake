namespace :db do
  namespace :fixtures do
    desc "Writes fixtures from the database to the filesystem"
    task dump: :environment do
      Rails.application.eager_load!
      models = defined?(ApplicationRecord) ? ApplicationRecord.descendants : ActiveRecord::Base.descendants
      models.each do |model|
        model_name = model.name.pluralize.underscore
        File.open("#{Rails.root}/test/fixtures/#{model_name}.yml", "w") do |file|
          file.write model.all.map(&:attributes).map { |el|  { el["id"] => el.except("created_at", "updated_at") } }.reduce { |a, b| a.merge(b) }.to_yaml
        end
      end
    end
  end
end
