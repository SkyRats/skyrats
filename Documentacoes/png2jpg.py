
#!/usr/bin/env python
from glob import glob                                                           
import cv2 
pngs = glob('./*.png')

for j in pngs:
    for i in os.listdir(j):
    	img = cv2.imread(j)
    	print("Converting + " str(i))
	cv2.imwrite(j[:-3] + 'jpg', img)
