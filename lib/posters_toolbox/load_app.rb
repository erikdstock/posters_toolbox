require "dotenv"

module PostersToolbox
  def self.load_app!
    Dotenv.load
    $app = PostersToolbox::App.new

    # $options = parse_options
  end
end
