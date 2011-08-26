require 'gtk2'
require 'eventmachine'

class MyApp

  def initialize
    #EM::connect ...
  end
end

EM::run do
  client = MyApp.new
  give_tick = proc { Gtk::main_iteration; EM.next_tick(give_tick); }
  give_tick.call
end

