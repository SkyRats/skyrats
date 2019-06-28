#!/usr/bin/env python
import os
import cv2

for j in os.listdir("./"):
    try:
	os.rename(j, j[-3:])
    except Exception as e:
    	print(e)
