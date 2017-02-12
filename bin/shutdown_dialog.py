#!/usr/bin/env python2

# Copyright (C) 2016, 2017 Andrew Kravchuk <awkravchuk@gmail.com>,
#  Simon Vermeersch <simonvermeersch@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import pygtk
pygtk.require('2.0')
import gtk
import os
import dbus
import dbus.mainloop.glib
import dbus.service


cancel_icon = '/usr/share/icons/nuoveXT2/32x32/actions/gtk-cancel.png'
reboot_icon = '/usr/share/icons/nuoveXT2/32x32/apps/gnome-session-reboot.png'
shutdown_icon = '/usr/share/icons/nuoveXT2/32x32/actions/stock_exit.png'
suspend_icon = '/usr/share/icons/nuoveXT2/32x32/apps/gnome-session-suspend.png'
service_name = 'org.ShutdownDialog'


def set_icon(button, icon):
        image = gtk.Image()
        image.set_from_file(icon)
        button.set_image(image)


class ShutdownDialog:
    def delete_event(self, widget, event, data=None):
            gtk.main_quit()
            return False

    def keypress(self, widget, event):
            if event.keyval == gtk.keysyms.Escape:
                    gtk.main_quit()

    def suspend(self, widget):
            gtk.mainquit()
            os.system("sudo pm-hibernate")

    def reboot(self, widget):
            gtk.mainquit()
            os.system("sudo reboot")

    def shutdown(self, widget):
            gtk.mainquit()
            os.system("sudo halt")

    def __init__(self):
            settings = gtk.settings_get_default()
            settings.props.gtk_button_images = True

            # Create a new window
            self.window = gtk.Window(gtk.WINDOW_TOPLEVEL)
            self.window.set_title(" ")
            self.window.set_resizable(False)
            self.window.set_position(1)
            self.window.connect("key-press-event", self.keypress)
            self.window.connect("delete_event", self.delete_event)
            self.window.set_border_width(10)

            # Create a box to pack widgets into
            self.box1 = gtk.HBox(False, 0)
            self.window.add(self.box1)

            # Create cancel button
            self.button1 = gtk.Button(" Cancel ")
            set_icon(self.button1, cancel_icon)
            self.button1.set_border_width(10)
            self.button1.connect("clicked", self.delete_event,
                                 "Changed me mind :)")
            self.box1.pack_start(self.button1, True, True, 0)
            self.button1.show()

            # Create reboot button
            self.button3 = gtk.Button(" Reboot ")
            set_icon(self.button3, reboot_icon)
            self.button3.set_border_width(10)
            self.button3.connect("clicked", self.reboot)
            self.box1.pack_start(self.button3, True, True, 0)
            self.button3.show()

            # Create shutdown button
            self.button4 = gtk.Button("Shutdown")
            set_icon(self.button4, shutdown_icon)
            self.button4.set_border_width(10)
            self.button4.connect("clicked", self.shutdown)
            self.box1.pack_start(self.button4, True, True, 0)
            self.button4.show()

            # Create suspend button
            self.button2 = gtk.Button(" Suspend ")
            set_icon(self.button2, suspend_icon)
            self.button2.set_border_width(10)
            self.button2.connect("clicked", self.suspend)
            self.box1.pack_start(self.button2, True, True, 0)
            self.button2.show()

    def show(self):
            self.box1.show()
            self.window.show()
            self.window.present()


class DbusService(dbus.service.Object):
        '''
        http://www.eurion.net/python-snippets/snippet/Single%20Instance.html
        '''
        def __init__(self, dialog):
            self.dialog = dialog
            bus_name = dbus.service.BusName(service_name,
                                            bus=dbus.SessionBus())
            dbus.service.Object.__init__(self, bus_name, '/org/ShutdownDialog')

        @dbus.service.method(dbus_interface=service_name)
        def show_window(self):
            self.dialog.show()


def main():
        dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
        if dbus.SessionBus().request_name(service_name) != \
           dbus.bus.REQUEST_NAME_REPLY_PRIMARY_OWNER:
                print("Shutdown dialog: already running")
                method = dbus.SessionBus().get_object(
                    service_name, '/org/ShutdownDialog').get_dbus_method(
                        'show_window')
                method()
        else:
                service = DbusService(ShutdownDialog())
                service.show_window()
                gtk.main()


if __name__ == "__main__":
        main()
