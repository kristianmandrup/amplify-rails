require 'rails'

module Amplify
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      @@amplify_version     = "1.0.beta"

      desc "This generator installs Amplify #{@@amplify_version}"

      class_option :packs,    :type => :array,    :default => [],   :banner => 'amplify packs to install'
      class_option :minified, :type => :boolean,  :default => true, :banner => 'minified scripts?'

      source_root File.expand_path('../../vendor/assets', __FILE__)

      def copy_amplify_zip    
        
        say_status("copying #{amplify}", :green)

        copy_complete amplify if packs.empty?

        if !packs.empty?          
          (packs & valid_packs).each do |pack|
            copy_individual pack
          end
        end
      end
      
      protected

      def valid_packs
        [:core, :request, :store] 
      end

      def copy_complete package
        copy_file package, target_name(package)
      end

      def copy_individual pack
        copy_file File.join('individual', pack), target_name(File.join('individual', pack))
      end

      def target_name name
        File.join(js_asset_target_folder, name)
      end

      def amplify
        js_name 'amplify'
      end
      
      def js_name name
        minified? ? "#{name}.min.js" : "#{name}.js"
      end
        
      
      def js_asset_target_folder
        File.join(Rails.root, "vendor/assets/javascripts"
      end

      def packs
        options.packs.map(&:to_sym)
      end
      
      include GeneratorHelper::Asset
    end
  end
end
