module SpreeSwiper
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, :type => :boolean, :default => false

      def add_javascripts
      end

      def add_stylesheets
      end

      def add_migrations
      end

      def run_migrations
      end
    end
  end
end
