# frozen_string_literal: true

require 'csv'
require 'open-uri'

require 'active_model'

def get_remote(url)
  @data = JSON.parse(URI.parse(url).read)
end

@manifests = CSV.read('lib/manifests-iiif/manifests.csv', headers: true)

namespace :iiif do
  desc 'Evaluate IIIF manifest items and create Resource objects'
  task evaluate: :environment do
    # Temporary URL
    @manifests.each do |manifest|
      grant = Grant.find_or_create_by(
        {
          title: manifest['project_title'],
          institution: manifest['lead_institution'],
          grant_number: manifest['clir_grant_number'],
          contact: manifest['contact_name'],
          email: manifest['contact_email'],
          submission: manifest['submission_date']
        }
      )

      get_remote(manifest['iiif_manifest_url'])

      @data['items'].each do |canvas|
        canvas['items'].each do |page|
          page['items'].each do |item|
            resource = Resource.find_or_create_by(
              {
                access_filename: item['id'],
                access_url: item['body']['id'],
                restricted: false,
                grant_id: grant.id
              }
            )
            pp resource
          end
        end
      end

      # @data['items'].each do |canvas|
      #     canvas['items'].each do |page|
      #         page['items'].each do |item|
      #             type = item['body']['type']
      #             if type == 'Image'
      #                 url = item['body']['id']
      #             end
      #         end
      #     end
      # end
    end

    # first['items'].first['items'].first['body']['id']
  end
end
