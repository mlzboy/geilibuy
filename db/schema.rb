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

ActiveRecord::Schema.define(:version => 20110916123057) do

  create_table "addresses", :force => true do |t|
    t.string   "consignee"
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "district_id"
    t.string   "address"
    t.string   "tel"
    t.string   "mobile"
    t.integer  "delivery_time_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "zipcode"
    t.integer  "user_id"
    t.integer  "rate",             :default => 0
  end

  create_table "advices", :force => true do |t|
    t.text     "content"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_categories", :force => true do |t|
    t.string   "name"
    t.integer  "position",   :default => 0
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tuangou",    :default => false
    t.integer  "parent_id"
  end

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "article_category_id"
  end

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.text     "story"
    t.string   "i1_file_name"
    t.string   "i1_content_type"
    t.integer  "i1_file_size"
    t.datetime "i1_updated_at"
    t.string   "i2_file_name"
    t.string   "i2_content_type"
    t.integer  "i2_file_size"
    t.datetime "i2_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",        :default => 0
    t.boolean  "hide",            :default => false
  end

  create_table "brands_categories", :id => false, :force => true do |t|
    t.integer "brand_id"
    t.integer "category_id"
    t.boolean "selected",    :default => false
    t.integer "position",    :default => 0
  end

  create_table "cash_details", :force => true do |t|
    t.integer  "user_id"
    t.decimal  "money",         :precision => 15, :scale => 3, :default => 0.0
    t.text     "memo"
    t.boolean  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tuangou",                                      :default => false
    t.decimal  "total_money",   :precision => 15, :scale => 3, :default => 0.0
    t.integer  "order_id"
    t.integer  "cash_order_id"
    t.string   "sn"
  end

  create_table "cash_orders", :force => true do |t|
    t.string   "sn"
    t.integer  "user_id"
    t.boolean  "tuangou",                                     :default => false
    t.integer  "payment_id"
    t.string   "ip"
    t.string   "payment_name"
    t.integer  "new_scores",                                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "description"
    t.decimal  "money",        :precision => 15, :scale => 3, :default => 0.0
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
    t.integer  "parent_id"
    t.integer  "position",        :default => 0
    t.boolean  "special",         :default => false
    t.string   "i1_file_name"
    t.string   "i1_content_type"
    t.integer  "i1_file_size"
    t.datetime "i1_updated_at"
  end

  create_table "categories_products", :id => false, :force => true do |t|
    t.integer  "product_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",    :default => 0
  end

  create_table "comment_shows", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "memo"
    t.string   "kind"
  end

  create_table "comment_shows_postsale_comments", :id => false, :force => true do |t|
    t.integer "comment_show_id"
    t.integer "postsale_comment_id"
    t.integer "position",            :default => 0
  end

  create_table "coupons", :force => true do |t|
    t.string   "name"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "user_id"
    t.string   "status"
    t.string   "kind"
    t.string   "code"
    t.string   "from"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "min_products_num",                                :default => 0
    t.boolean  "hide",                                            :default => false
    t.decimal  "min_money",        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "money",            :precision => 15, :scale => 3, :default => 0.0
    t.integer  "order_id"
  end

  create_table "deliveries", :force => true do |t|
    t.string   "name"
    t.text     "memo"
    t.integer  "position",                                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "p1",         :precision => 15, :scale => 3, :default => 0.0
    t.boolean  "special",                                   :default => false
    t.boolean  "hide",                                      :default => false
  end

  create_table "delivery_companies", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_statuses", :force => true do |t|
    t.integer  "order_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_times", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",   :default => 0
  end

  create_table "educations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.integer  "last_send_attempt", :default => 0
    t.text     "mail"
    t.datetime "created_on"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rate",       :default => 0
  end

  create_table "free_shipping_rules", :force => true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "money",      :precision => 15, :scale => 3, :default => 0.0
  end

  create_table "gifts", :force => true do |t|
    t.string   "name"
    t.text     "memo"
    t.string   "uuid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "position",   :default => 0
    t.boolean  "leaf",       :default => true
  end

  create_table "gifts_products", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "gift_id"
  end

  create_table "invite_details", :force => true do |t|
    t.integer  "invite_id"
    t.string   "name"
    t.integer  "value",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", :force => true do |t|
    t.boolean  "tuangou",         :default => false
    t.integer  "user_id"
    t.integer  "invited_user_id"
    t.string   "ip"
    t.string   "from"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kindeditor_images", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.datetime "data_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lotteries", :force => true do |t|
    t.integer  "first_num",   :default => 0
    t.integer  "second_num",  :default => 0
    t.integer  "third_num",   :default => 0
    t.integer  "first_rate",  :default => 300
    t.integer  "second_rate", :default => 200
    t.integer  "third_rate",  :default => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lottery_details", :force => true do |t|
    t.integer  "user_id"
    t.text     "say"
    t.boolean  "big"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "total_lucky"
    t.boolean  "winning",     :default => false
  end

  create_table "materials", :force => true do |t|
    t.string   "name"
    t.string   "hyperlink"
    t.string   "title"
    t.string   "alt"
    t.string   "text"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url_file_name"
    t.string   "image_url_content_type"
    t.integer  "image_url_file_size"
    t.datetime "image_url_updated_at"
    t.string   "size"
    t.string   "kind"
  end

  create_table "materials_slots", :id => false, :force => true do |t|
    t.integer "material_id"
    t.integer "slot_id"
    t.integer "position"
  end

  create_table "order_products", :force => true do |t|
    t.string   "name"
    t.integer  "product_id"
    t.integer  "order_id"
    t.integer  "num"
    t.boolean  "promotion",                                  :default => false
    t.decimal  "p1",          :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "p2",          :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "p3",          :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "p4",          :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "p5",          :precision => 15, :scale => 3, :default => 0.0
    t.string   "sub_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cost_scores",                                :default => 0
    t.integer  "new_scores",                                 :default => 0
    t.integer  "user_id"
    t.integer  "s1"
    t.boolean  "score"
    t.boolean  "tuangou",                                    :default => false
  end

  create_table "order_statuses", :force => true do |t|
    t.integer  "order_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "value",         :default => 1
    t.integer  "cash_order_id"
    t.boolean  "tuangou",       :default => false
    t.string   "from"
    t.string   "url"
    t.string   "ip"
    t.string   "sn"
    t.string   "memo"
  end

  create_table "order_suite_products", :force => true do |t|
    t.integer  "product_show_id"
    t.integer  "order_suite_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "order_suites", :force => true do |t|
    t.string   "name"
    t.integer  "num"
    t.decimal  "suite_price",     :precision => 15, :scale => 3, :default => 0.0
    t.integer  "suite_num"
    t.integer  "integer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_show_id"
    t.integer  "order_id"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.string   "sn"
    t.string   "ip"
    t.integer  "payment_id"
    t.integer  "delivery_id"
    t.decimal  "products_price",        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_price",           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "delivery_price",        :precision => 15, :scale => 3, :default => 0.0
    t.integer  "products_num",                                         :default => 0
    t.string   "consignee"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "address"
    t.string   "tel"
    t.string   "mobile"
    t.string   "delivery_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "delivery_name"
    t.string   "payment_name"
    t.decimal  "real_money",            :precision => 15, :scale => 3, :default => 0.0
    t.text     "memo"
    t.integer  "cost_scores",                                          :default => 0
    t.integer  "new_scores",                                           :default => 0
    t.integer  "tuan_id"
    t.integer  "delivery_company_id"
    t.string   "delivery_company_name"
    t.string   "delivery_no"
    t.integer  "product_rank",                                         :default => -2
    t.boolean  "tuangou",                                              :default => false
    t.integer  "delivery_rank",                                        :default => -2
    t.integer  "package_rank",                                         :default => -2
    t.text     "tuan_comment"
    t.text     "comment"
    t.decimal  "cash_money",            :precision => 15, :scale => 3, :default => 0.0
    t.boolean  "dispatch_scores",                                      :default => false
    t.integer  "coupon_id"
    t.decimal  "coupon_money",          :precision => 15, :scale => 3, :default => 0.0
    t.boolean  "free_shipping",                                        :default => false
  end

  create_table "payment_statuses", :force => true do |t|
    t.integer  "order_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "from"
    t.string   "total_fee"
    t.string   "transaction_id"
    t.string   "sn"
    t.text     "url"
    t.boolean  "success",        :default => false
    t.string   "ip"
    t.string   "memo"
    t.boolean  "tuangou",        :default => false
    t.integer  "cash_order_id"
  end

  create_table "payments", :force => true do |t|
    t.string   "name"
    t.text     "memo"
    t.integer  "parent_id"
    t.integer  "position",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "i1_file_name"
    t.string   "i1_content_type"
    t.integer  "i1_file_size"
    t.datetime "i1_updated_at"
    t.boolean  "hide",            :default => false
    t.string   "code"
    t.boolean  "special",         :default => false
    t.boolean  "tuangou",         :default => false
  end

  create_table "postsale_comments", :force => true do |t|
    t.text     "content"
    t.text     "reply"
    t.string   "ip"
    t.integer  "product_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hide",       :default => false
    t.integer  "creative",   :default => 0
    t.integer  "feature",    :default => 0
    t.integer  "quality",    :default => 0
    t.boolean  "value",      :default => false
  end

  create_table "presale_consultings", :force => true do |t|
    t.text     "content"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reply"
    t.integer  "product_id"
    t.boolean  "value",      :default => false
    t.boolean  "hide",       :default => false
    t.integer  "user_id",    :default => -1
    t.boolean  "satisfy"
  end

  create_table "product_shows", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "location"
    t.text     "memo"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
    t.boolean  "suite",                                                 :default => false
    t.boolean  "suite_on",                                              :default => false
    t.string   "suite_name"
    t.integer  "suite_num",                                             :default => 0
    t.decimal  "suite_price",            :precision => 15, :scale => 3, :default => 0.0
    t.string   "suite_pic"
    t.string   "suite_pic_file_name"
    t.string   "suite_pic_content_type"
    t.integer  "suite_pic_file_size"
    t.datetime "suite_pic_updated_at"
  end

  create_table "product_shows_products", :id => false, :force => true do |t|
    t.integer "product_show_id"
    t.integer "product_id"
    t.integer "position",        :default => 0
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.boolean  "promotion",                                      :default => false
    t.boolean  "new",                                            :default => true
    t.boolean  "score",                                          :default => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "i1_file_name"
    t.string   "i1_content_type"
    t.integer  "i1_file_size"
    t.datetime "i1_updated_at"
    t.string   "i2_file_name"
    t.string   "i2_content_type"
    t.integer  "i2_file_size"
    t.datetime "i2_updated_at"
    t.string   "i3_file_name"
    t.string   "i3_content_type"
    t.integer  "i3_file_size"
    t.datetime "i3_updated_at"
    t.string   "i4_file_name"
    t.string   "i4_content_type"
    t.integer  "i4_file_size"
    t.datetime "i4_updated_at"
    t.string   "weight"
    t.string   "size"
    t.string   "material"
    t.text     "editor"
    t.text     "caution"
    t.integer  "brand_id"
    t.string   "sub_title"
    t.integer  "sale",                                           :default => 0
    t.integer  "view",                                           :default => 0
    t.integer  "stock",                                          :default => 0
    t.boolean  "on",                                             :default => true
    t.string   "wrap"
    t.integer  "s1",                                             :default => 0
    t.decimal  "p1",              :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "p2",              :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "p3",              :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "p4",              :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "p5",              :precision => 15, :scale => 3, :default => 0.0
    t.text     "memo"
    t.string   "style"
    t.integer  "position",                                       :default => 0
    t.integer  "lucky",                                          :default => 0
    t.boolean  "big",                                            :default => false
    t.datetime "p4_end_time"
  end

  create_table "qas", :force => true do |t|
    t.integer  "user_id"
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hide",       :default => false
    t.string   "ip"
    t.integer  "tuan_id"
  end

  create_table "regions", :force => true do |t|
    t.string  "name"
    t.integer "parent_id"
    t.integer "level"
    t.integer "position",  :default => 0
  end

  create_table "score_details", :force => true do |t|
    t.integer  "user_id"
    t.integer  "score"
    t.text     "memo"
    t.boolean  "cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tuangou",       :default => false
    t.integer  "order_id"
    t.integer  "cash_order_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "slots", :force => true do |t|
    t.integer  "category_id"
    t.string   "name"
    t.string   "location"
    t.string   "size"
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
  end

  create_table "subscriptions", :force => true do |t|
    t.string   "email"
    t.boolean  "subscribe",  :default => true
    t.boolean  "tuan",       :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tuan_details", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "position",   :default => 0
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tuan_id"
  end

  create_table "tuans", :force => true do |t|
    t.integer  "product_id"
    t.string   "status",                                          :default => "抢购"
    t.decimal  "pp1",              :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "dp1",              :precision => 15, :scale => 3, :default => 0.0
    t.integer  "dp1_num",                                         :default => 1
    t.integer  "integer",                                         :default => 2
    t.decimal  "dp2",              :precision => 15, :scale => 3, :default => 0.0
    t.integer  "dp2_num",                                         :default => 2
    t.string   "title"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "min_time"
    t.integer  "min_num",                                         :default => 10
    t.datetime "max_time"
    t.integer  "max_num",                                         :default => 0
    t.boolean  "on",                                              :default => true
    t.text     "ts1"
    t.string   "ts1_name"
    t.text     "ts2"
    t.string   "ts2_name"
    t.text     "ts3"
    t.string   "ts3_name"
    t.text     "ws1"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "i1_file_name"
    t.string   "i1_content_type"
    t.integer  "i1_file_size"
    t.datetime "i1_updated_at"
    t.decimal  "pp2",              :precision => 15, :scale => 3, :default => 0.0
    t.integer  "current_num",                                     :default => 0
    t.string   "sub_title"
    t.integer  "everyone_max_num",                                :default => 0
    t.string   "edm_title"
  end

  create_table "upload_photos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.boolean  "hide",            :default => true
    t.text     "memo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "i1_file_name"
    t.string   "i1_content_type"
    t.integer  "i1_file_size"
    t.datetime "i1_updated_at"
  end

  create_table "user_details", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "gender",       :default => false
    t.integer  "job_id"
    t.integer  "education_id"
    t.datetime "birthday"
    t.text     "introduce"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.boolean  "active"
    t.string   "active_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nick"
    t.integer  "score",                                       :default => 0
    t.integer  "lucky",                                       :default => 0
    t.decimal  "money",        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "return_money", :precision => 15, :scale => 3, :default => 0.0
    t.integer  "kind",                                        :default => 0
  end

  create_table "vote_details", :force => true do |t|
    t.string   "ip"
    t.integer  "vote_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", :force => true do |t|
    t.string   "name"
    t.integer  "position",   :default => 0
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
