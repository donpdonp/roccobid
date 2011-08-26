require 'gtk2'
require 'eventmachine'
require 'json'

class MyApp

  def initialize(window, thash)
    #EM::connect ...
    @window = window
    window_signals
    build_ui
    @window.show_all
    
    thash.burp
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
    puts "Connected to telehash.org"
  end
  
  def receive_data(data)
    json = JSON.parse(data)
    puts "#{json.inspect}"
    @my_address = json["_to"]
  end

  def burp
    send_datagram '{"+end":"a9993e364706816aba3e25717850c26c9cd0d89d"}', "telehash.org", 42424
  end
end

EM::run do
  thash = EventMachine::open_datagram_socket "0.0.0.0", 0, Thash

  window = Gtk::Window.new
  client = MyApp.new(window, thash)
  
  EventMachine::PeriodicTimer.new(1) do
    client.label_text = Time.now.to_s
  end
  
  give_tick = proc { Gtk::main_iteration; EM.next_tick(give_tick); }
  give_tick.call
end

