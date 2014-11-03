require 'action_view/template/handlers/twiml'

module TwiML
  class Railtie < Rails::Railtie
    initializer "twiml.configure_templates" do |app|
      config.after_initialize do
        Mime::Type.register "text/xml", :twiml
        ActiveSupport.on_load(:action_view) do
          ActionView::Template.register_template_handler(
            :twiml,
            ActionView::Template::Handlers::TwiML
          )
        end
      end
    end
  end
end
