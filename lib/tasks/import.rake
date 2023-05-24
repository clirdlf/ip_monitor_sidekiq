# frozen_string_literal: true
require 'active_model'
require 'chronic'
require 'colorize'
require 'roo'

require 'ipmonitor/manifest'

namespace :import do
  desc 'Test validity of manifests'
  task validate: [:environment] do
    Dir.glob('lib/manifests/*.xlsx').each do |file|
      puts "Checking #{file}".yellow
      # TODO: test that stuff is in the file
      manifest = Manifest.new(file)
      # manifest.validate
      puts manifest.validate!
    end
  end

  desc 'Import reports in to the database'
  task manifests: [:environment] do
    Dir.glob('lib/manifests/*.xlsx').each do |file|
      puts "Processing #{file}".green
      manifest = Manifest.new(file)
      filename = File.basename(file)

      # TODO: Don't import already created grants
      grant = Grant.find_or_create_by(
        {
            title: manifest.title,
            institution: manifest.institution,
            grant_number: manifest.grant_number,
            contact: manifest.contact,
            email: manifest.email,
            submission: manifest.submission,
            filename: filename
        }
      )

      manifest.resources.each do |resource|
        # restriction = ActiveModel::Type::Boolean.new.cast(resource[:restricted])
        unless resource[:checksum] == 'CHECKSUM'
          Resource.find_or_create_by(
            {
              access_filename: resource[:access_filename],
              access_url: resource[:access_url],
              checksum: resource[:checksum],
              # restricted: resource[:restricted].to_bool,
              restricted: Boolean(resource[:restricted]),
              restricted_comments: resource[:restricted_comments],
              grant_id: grant.id
            }
          ) unless resource[:restricted].nil?
        end

      end
    end
  end
end
