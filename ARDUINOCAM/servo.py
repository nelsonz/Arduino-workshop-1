#!/usr/bin/env python

# Servo controller/viewer local version, by Nelson Zhang 2011
# For use in XinCheJian Kino
# Requires: serial, pygame

import serial
import pygame
import pygame.camera
from pygame.locals import *

# Set Arduino COM port, baud rate, timeout flag
# Windows:   'COM5'
# Linux:     '/dev/ttyUSB0'
# Mac:       '/dev/tty.usbserial-FTALLOK2'
ser = serial.Serial('COM4', 9600, timeout=1)

# Set resolution here
res = (640, 480)

# global variable: current servo angles
angles = {2:90, 3:145}

# Move servo to angle
# servo: (2, 3); 2 = bottom, 3 = top
# angle = [0,180]
def move(servo, pos):
    if servo == 3 and pos > 165:
        pos = 165
    if (0 <= pos <= 180):
        ser.write(chr(255))
        ser.write(chr(servo))
        ser.write(chr(pos))
        angles[servo] = pos
    else:
        pass

# Move camera to forward-facing (home) position
def home():
    move(2, 90)
    move(3, 145)


# Capture object for getting camera data and displaying to screen
# FPS-style mouse control and arrow key control
class Capture(object):
    def __init__(self, size=res, s=5):
        self.size = size
        self.s = s
        self.display = pygame.display.set_mode(self.size, 0)
        # Get list of cameras and choose the first connected port
        self.camlist = pygame.camera.list_cameras()
        if not self.camlist:
            raise ValueError("No cameras detected!")
        self.cam = pygame.camera.Camera(1, self.size)
        self.cam.start()
        self.snapshot = pygame.surface.Surface(self.size, 0, self.display)

    # Blit frame to screen
    def get_and_flip(self):
        self.snapshot = self.cam.get_image(self.snapshot)
        self.display.blit(self.snapshot, (0,0))
        pygame.display.flip()

    # Main loop
    # Get key presses and mouse movements, translate to servo movements
    def main(self):
        run = True
        while run:
            events = pygame.event.get()
            for event in events:
                # Quit safely if user presses ESC
                if event.type == QUIT or (event.type == KEYDOWN and event.key == K_ESCAPE):
                    self.cam.stop()
                    run = False

                # Return camera to home position if users presses SPACE
                if event.type == KEYDOWN and event.key == K_SPACE:
                    home()

            # If the mouse is pressed, activate scale mouse position to servo angles
            if pygame.mouse.get_pressed()[0]:
                mpos = pygame.mouse.get_pos()
                move(2, int((180.0 * mpos[0])/self.size[0]))
                move(3, 165 - int((165.0 * mpos[1])/self.size[1]))  # Servo 3 cannot extend past 165

            # Get list of pressed keys; move servos accordingly with constant sensitivity
            pressedkeys = pygame.key.get_pressed()
            if pressedkeys[K_RIGHT]:
                move(2, angles[2] + self.s)
            elif pressedkeys[K_LEFT]:
                move(2, angles[2] - self.s)
            if pressedkeys[K_UP]:
                move(3, angles[3] + self.s)
            elif pressedkeys[K_DOWN]:
                move(3, angles[3] - self.s)

            self.get_and_flip()


# Start the Kino controller/viewer
def start():
    # Initialize pygame
    pygame.init()
    pygame.camera.init()

    # Initialize the screen
    screen = pygame.display.set_mode(res)
    pygame.display.set_caption("XinCheJian Kino")

    Cap = Capture()
    Cap.main()
