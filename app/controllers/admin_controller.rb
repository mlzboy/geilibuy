class AdminController < ApplicationController
before_filter :admin_login?
end