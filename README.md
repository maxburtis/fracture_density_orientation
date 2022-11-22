# fracture_density_orientation
## Juneau Icefield Fracture Density and Orientation Mapping Project 
To run this code clone the repo or download the following files:
  * 'FractureProcessing.m'
  * 'mat2tiles.m'

and place them in the working directory of your MATLAB session. Load the image that you will be processing into the working directory and open 'FractureProcessing.m'

Next, update line #5 ```colorImage = imread('cliff_rgb.jpeg');``` with the name of the image that you are trying to analyze. 

After this, line #76 ```cells = mat2tiles(refined,[54, 54])``` will need to be updated with the number of pixels in 2 meters (currently set to 54). 

Then run the script and view the figures. An example output is provided below: 

![example](https://github.com/maxburtis/fracture_density_orientation/blob/main/example.jpg)
