require 'gtk2'
require 'eventmachine'

class MyApp

  def initialize(window)
    #EM::connect ...
    @window = window
    window_signals
    build_ui
    @window.show_all
  end
  
  def label_text=(text)
    @label.set_text(text)
  end

  private
  
  def window_signals
    @window.signal_connect("destroy") {
      puts "destroy event occurred"
      Gtk.main_quit
    }
  end
  
  def build_ui
    vbox = Gtk::VBox.new
    @button = Gtk::Button.new("Hello World")
    vbox.add(@button)
    @label = Gtk::Label.new("Label")
    vbox.add(@label)
    @window.add(vbox)
  end
end

EM::run do
  window = Gtk::Window.new
  client = MyApp.new(window)
  client.label_text = "whoo"
  
  EventMachine::PeriodicTimer.new(1) do
    client.label_text = Time.now.to_s
  end
  
  give_tick = proc { Gtk::main_iteration; EM.next_tick(give_tick); }
  give_tick.call
end

