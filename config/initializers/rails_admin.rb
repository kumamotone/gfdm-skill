RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
     warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
  
  # password_digest の更新でコケるため
  config.model User do
    update do
      exclude_fields :password_digest
    end
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end

module RailsAdmin 
  module Config 
    module Fields 
      module Types
        # http://qiita.com/ron214_ron/items/8dfc77b75ab28a665b79
        # datetime の日付のフォーマットが日本語になってしまいパースできないバグに対するMonkey Patch
        class Datetime < RailsAdmin::Config::Fields::Base
          register_instance_option :date_format do 
            :default
          end
        end
        class Date < RailsAdmin::Config::Fields::Types::Datetime 
          register_instance_option :date_format do 
            :default
          end
        end
      end 
        # https://github.com/sferik/rails_admin/issues/2150
        # class Password
          # def parse_input(params) end
        # end
    end 
  end
end
