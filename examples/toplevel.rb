$0 = 'hello'

require 'tk'

Tk.appname('SuperlongTest')
root = TkRoot.new { title 'Test' }
TkToplevel.new(root, class: 'Toplevel')
Tk.mainloop
