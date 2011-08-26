require 'gtk2'
require 'eventmachine'
require 'json'

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
    @window.signal_connect("destroy") { EventMachine::stop_event_loop }
  end
  
  def build_ui
    vbox = Gtk::VBox.new
    @button = Gtk::Button.new("Hello World")
    vbox.add(@button)
    @label = Gtk::Label.new("Time")
    vbox.add(@label)
    @window.add(vbox)
  end
end

module Thash
  def post_init
    puts "post init UDP"
  end
  
  def receive_data(data)
    json = JSON.parse(data)
    puts "#{json.inspect}"
  end
end

EM::run do
  window = Gtk::Window.new
  client = MyApp.new(window)
  
  EventMachine::PeriodicTimer.new(1) do
    client.label_text = Time.now.to_s
  end
  
  thash = EventMachine::open_datagram_socket "0.0.0.0", 0, Thash
  thash.send_datagram '{"+end":"3b6a6..."}', "telehash.org", 42424
  
  give_tick = proc { Gtk::main_iteration; EM.next_tick(give_tick); }
  give_tick.call
end

