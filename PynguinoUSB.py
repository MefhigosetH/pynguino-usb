#!/usr/bin/python
#-*- coding: utf-8 -*-
#
# Author: Victor Villarreal <mefhigoseth@gmail.com>
# License: MIT
# Brief:
# Controlling Pinguino 2550 board through PyUSB.
# Based on the great work of Yeison Nolberto Cardona Álvarez <yeison.eng@gmail.com>

import usb

class PynguinoUSB():

	dev = 0
	connected = 0

	#--------------------------------------------------------------------------
	# Constructor method
	def __init__(self):

		# idVendor/idProduct corresponding to PIC18F2550.
		# In Linux, you can get the pair VendorId:ProductId from 'lsusb' command.
		self.dev = usb.core.find(idVendor=0x04d8, idProduct=0xfeaa) 

		# If dev is None, then can't find the device. It's connected ?
		if self.dev is None:
			return None

		# When connected, the Linux Kernel assign a driver to this device...
		# To work ok, this software need to detach the current assigned driver.
		if self.dev.is_kernel_driver_active(0) is True:
			self.dev.detach_kernel_driver(0)

		self.dev.set_configuration()

		# If all is OK, we should get an answer...
		buffer = self.dev.write(1, '$', 0, 500)
		self.response = self.dev.read(0x81,4)
		if chr(self.response[0])=="$":
			self.connected = 1

		return None

	#--------------------------------------------------------------------------
	# Toggle status of a digital pin
	def Toggle(self,pin):
		buffer = self.dev.write(1, 'T'+chr(pin+48), 0, 500)
		return buffer
