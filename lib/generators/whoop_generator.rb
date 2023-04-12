class WhoopGenerator < Rails::Generators::Base
  def install
    create_file "config/initializers/whoop.rb", "# Add initialization content here"
  end
end
