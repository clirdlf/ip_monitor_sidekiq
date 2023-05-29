# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_200_706_144_129) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'grants', force: :cascade do |t|
    t.string 'title'
    t.string 'institution'
    t.string 'grant_number'
    t.string 'contact'
    t.string 'email'
    t.date 'submission'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'program'
    t.integer 'resources_count'
    t.string 'filename'
    t.index ['filename'], name: 'index_grants_on_filename', unique: true
  end

  create_table 'ija_data', id: false, force: :cascade do |t|
    t.bigint 'level_0'
    t.bigint 'index'
    t.text 'annotation_location'
    t.text 'annotation'
    t.text 'annotations'
    t.text 'archival_materials_format'
    t.text 'archival_materials_type'
    t.text 'attachments'
    t.text 'author_corporate'
    t.text 'author_personal'
    t.text 'binding_detached_or_loose'
    t.text 'binding_distorted'
    t.text 'binding_format'
    t.text 'binding_missing'
    t.text 'binding_moldy_or_dirty'
    t.text 'binding_rusty'
    t.text 'binding_stained'
    t.text 'blocked'
    t.float 'blocking_inhibited_photography'
    t.text 'book_format'
    t.text 'box_number_2014'
    t.float 'box_number'
    t.float 'box_number/#agg'
    t.text 'box_type_2014'
    t.text 'cataloger_name'
    t.bigint 'comment_count'
    t.bigint 'comment_count/#agg'
    t.text 'condition_note'
    t.text 'content_note'
    t.text 'cover_material'
    t.float 'crate_number'
    t.float 'crate_number_2014'
    t.float 'crate_number_2014/#agg'
    t.text 'date_created'
    t.text 'date_of_publication_hebrew'
    t.text 'date_of_publication'
    t.text 'decade_of_publication'
    t.text 'depth'
    t.text 'descriptive_title'
    t.float 'digitization_information'
    t.text 'disbound_disassembled'
    t.float 'dpi'
    t.float 'dpi/#agg'
    t.text 'exhibit'
    t.text 'flattening'
    t.text 'form_genre'
    t.text 'format_note'
    t.text 'fused'
    t.text 'general_note'
    t.text 'geographic_note'
    t.text 'height'
    t.text 'ija_dup_imaged'
    t.bigint 'ija_number'
    t.bigint 'ija_number/#agg'
    t.float 'image_count'
    t.float 'image_count/#agg'
    t.text 'imaging'
    t.bigint 'include_pdf'
    t.bigint 'include_pdf/#agg'
    t.float 'inclusive_end_date'
    t.float 'inclusive_end_date/#agg'
    t.float 'inclusive_start_date'
    t.float 'inclusive_start_date/#agg'
    t.text 'keywords'
    t.text 'language_or_alphabet'
    t.text 'media'
    t.text 'mended'
    t.text 'metadata'
    t.text 'mold_recommendation'
    t.text 'mold_remediation'
    t.float 'mold_treatment_time'
    t.float 'mold_treatment_time/#agg'
    t.text 'note'
    t.float 'oclc_number'
    t.float 'oclc_number/#agg'
    t.text 'other_treatment'
    t.bigint 'other'
    t.bigint 'other/#agg'
    t.text 'partial_view'
    t.text 'place_of_publication'
    t.text 'publisher'
    t.text 'ready'
    t.text 'record_creator'
    t.float 'record_id'
    t.text 'pdf'
    t.float 'record_id/#agg'
    t.text 'record_status'
    t.text 'record_type'
    t.text 'rehoused'
    t.text 'related_exhibit_page'
    t.text 'second_cataloger'
    t.text 'size'
    t.float 'sort_title'
    t.text 'text_or_paper_broken_or_detached'
    t.text 'text_or_paper_distorted'
    t.text 'text_or_paper_missing'
    t.text 'text_or_paper_moldy_or_dirty'
    t.text 'text_or_paper_rusty'
    t.text 'text_or_paper_stained'
    t.text 'thickness'
    t.text 'title_in_transliteration'
    t.text 'title'
    t.float 'total_treatment_time'
    t.float 'total_treatment_time/#agg'
    t.text 'treatment_needed'
    t.float 'trunk_of_origin'
    t.float 'trunk_of_origin/#agg'
    t.text 'updated_date'
    t.text 'width'
    t.text 'images'
    t.index ['level_0'], name: 'ix_ija_data_level_0'
  end

  create_table 'resources', force: :cascade do |t|
    t.string 'access_filename'
    t.string 'access_url'
    t.string 'checksum'
    t.boolean 'restricted'
    t.text 'restricted_comments'
    t.bigint 'grant_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'statuses_count'
    t.index ['grant_id'], name: 'index_resources_on_grant_id'
  end

  create_table 'statuses', force: :cascade do |t|
    t.string 'response_code'
    t.string 'response_message'
    t.decimal 'response_time'
    t.string 'status'
    t.boolean 'latest'
    t.text 'status_message'
    t.bigint 'resource_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['resource_id'], name: 'index_statuses_on_resource_id'
  end

  add_foreign_key 'resources', 'grants'
  add_foreign_key 'statuses', 'resources'
end
