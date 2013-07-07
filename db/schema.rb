# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121004140303) do

  create_table "activities_dates", :force => true do |t|
    t.integer  "gateway_id",                  :null => false
    t.datetime "token_request"
    t.datetime "configuration_request"
    t.datetime "measurement_upload"
    t.datetime "log_file_upload"
    t.datetime "time_request"
    t.datetime "configuration_state_request"
    t.datetime "system_state_upload"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities_dates", ["gateway_id"], :name => "index_activities_dates_on_gateway_id"

  create_table "configurations", :force => true do |t|
    t.integer  "gateway_id"
    t.integer  "network_1_id"
    t.integer  "network_2_id"
    t.integer  "network_3_id"
    t.integer  "ethernet_ip_assignment_method_id"
    t.string   "ethernet_ip"
    t.integer  "ethernet_mtu"
    t.string   "gprs_provider"
    t.string   "gprs_apn"
    t.integer  "gprs_mtu"
    t.integer  "configuration_update_interval",                               :null => false
    t.integer  "status_interval",                                             :null => false
    t.integer  "send_data_interval",                                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",                                                   :null => false
    t.string   "gprs_username"
    t.string   "tz_data",                                :default => "UTC+0", :null => false
    t.string   "pstn_username"
    t.string   "pstn_password"
    t.string   "pstn_dialin"
    t.integer  "pstn_mtu"
    t.string   "gprs_pin"
    t.string   "gprs_password"
    t.string   "ethernet_proxy_server"
    t.integer  "ethernet_proxy_port"
    t.string   "ethernet_proxy_username"
    t.string   "ethernet_proxy_password"
    t.boolean  "ethernet_proxy_ssl"
    t.string   "gprs_proxy_server"
    t.integer  "gprs_proxy_port"
    t.string   "gprs_proxy_username"
    t.string   "gprs_proxy_password"
    t.boolean  "gprs_proxy_ssl"
    t.string   "pstn_proxy_server"
    t.integer  "pstn_proxy_port"
    t.string   "pstn_proxy_username"
    t.string   "pstn_proxy_password"
    t.boolean  "pstn_proxy_ssl"
    t.integer  "connectors_mask"
    t.string   "gprs_phone_number"
    t.boolean  "modified",                               :default => true,    :null => false
    t.string   "repo_type",                                                   :null => false
    t.integer  "software_update_interval",                                    :null => false
    t.string   "ethernet_default_gateway_ip"
    t.string   "ethernet_dns_1"
    t.string   "ethernet_dns_2"
    t.boolean  "auto_update",                                                 :null => false
    t.boolean  "send_log_files",                                              :null => false
    t.string   "state_xml"
    t.text     "xml"
    t.integer  "temporal_configuration_update_interval"
    t.integer  "log_level",                              :default => 4
  end

  add_index "configurations", ["gateway_id"], :name => "index_configurations_on_gateway_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "gateways", :force => true do |t|
    t.integer  "project_id",                                   :null => false
    t.string   "serial_number",                                :null => false
    t.string   "mac_address",                                  :null => false
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_contact"
    t.datetime "authenticated_at"
    t.datetime "installed_at"
    t.boolean  "debug_mode",                :default => false
    t.string   "location"
    t.boolean  "synchronize_md"
    t.integer  "shutdown_action_id"
    t.integer  "vpn_action_id"
    t.boolean  "removemeasurements_action"
  end

  add_index "gateways", ["project_id"], :name => "index_gateways_on_project_id"
  add_index "gateways", ["token"], :name => "index_gateways_on_token"

  create_table "log_files", :force => true do |t|
    t.integer  "gateway_id"
    t.string   "file",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "log_files", ["gateway_id"], :name => "index_log_files_on_gateway_id"

  create_table "measurements", :force => true do |t|
    t.integer  "medical_device_id"
    t.string   "type",                                      :null => false
    t.integer  "session_id",                                :null => false
    t.datetime "measured_at",                               :null => false
    t.boolean  "transmitted_data_set",                      :null => false
    t.integer  "user",                                      :null => false
    t.datetime "registered_at",                             :null => false
    t.integer  "systolic"
    t.integer  "diastolic"
    t.integer  "pulse"
    t.integer  "glucose"
    t.decimal  "weight"
    t.decimal  "impedance"
    t.decimal  "body_fat"
    t.decimal  "body_water"
    t.decimal  "muscle_mass"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid",                        :limit => 36, :null => false
    t.integer  "failed_connectors_mask"
    t.integer  "successfuly_connectors_mask"
    t.string   "time_zone"
  end

  add_index "measurements", ["medical_device_id"], :name => "index_measurements_on_medical_device_id"
  add_index "measurements", ["uuid"], :name => "index_measurements_on_uuid"

  create_table "medical_device_states", :force => true do |t|
    t.integer  "system_state_id"
    t.string   "medical_device_serial_number", :null => false
    t.string   "connection_state"
    t.integer  "error_id"
    t.boolean  "bound"
    t.boolean  "low_battery"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "date"
    t.integer  "users_mask"
    t.integer  "default_user"
    t.datetime "last_modified"
  end

  add_index "medical_device_states", ["system_state_id"], :name => "index_medical_device_states_on_system_state_id"

  create_table "medical_device_users", :force => true do |t|
    t.integer  "medical_device_id"
    t.integer  "md_user"
    t.string   "gender"
    t.string   "physical_activity"
    t.integer  "age"
    t.integer  "height"
    t.string   "units"
    t.boolean  "display_body_fat"
    t.boolean  "display_body_water"
    t.boolean  "display_muscle_mass"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medical_device_users", ["medical_device_id"], :name => "index_medical_device_users_on_medical_device_id"

  create_table "medical_devices", :force => true do |t|
    t.integer  "gateway_id",    :null => false
    t.string   "serial_number", :null => false
    t.integer  "type_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medical_devices", ["gateway_id"], :name => "index_medical_devices_on_gateway_id"

  create_table "project_users", :force => true do |t|
    t.integer  "project_id", :null => false
    t.integer  "user_id",    :null => false
    t.string   "role",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_users", ["project_id"], :name => "index_project_users_on_project_id"
  add_index "project_users", ["user_id"], :name => "index_project_users_on_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "contact_person"
    t.string   "email"
    t.string   "address"
    t.string   "rmp_url",          :default => "https://localhost:3000/api",                  :null => false
    t.string   "medical_data_url", :default => "https://localhost:3000/api/measurements.xml", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "opkg_url",         :default => "http://opkg.biocomfort.de",                   :null => false
  end

  create_table "system_states", :force => true do |t|
    t.integer  "gateway_id"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "network"
    t.string   "firmware_version"
    t.integer  "gprs_signal"
    t.text     "packages"
  end

  add_index "system_states", ["gateway_id"], :name => "index_system_states_on_gateway_id"

  create_table "users", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",              :default => false, :null => false
    t.boolean  "superadmin"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

  add_foreign_key "medical_device_states", "system_states", :name => "medical_device_states_system_state_id_fk", :dependent => :delete

end
