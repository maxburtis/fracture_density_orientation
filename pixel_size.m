
surface_lat = 58.718505; 
surface_lon = -134.377119;
FOV=84;
filename='DJI_0133cropped.jpg';

info=imfinfo(filename);
camera_lat=dms2degrees(info.GPSInfo.GPSLatitude);
camera_lon=dms2degrees(info.GPSInfo.GPSLongitude);
camera_lon=camera_lon*-1;

meters_per_pixel=px_size(filename,FOV,surface_lat,surface_lon,camera_lat,camera_lon);
pixels_per_meter=1/meters_per_pixel;
pixels_in_2m=2*pixels_per_meter

function px_size=px_size(filename,FOV,surface_lat,surface_lon,camera_lat,camera_lon)
    image=imread(filename);
    [height, width, c]=size(image);
    d_km=distance(surface_lat,surface_lon,camera_lat,camera_lon);
    d_m=deg2km(d_km)*1000;
    w=2*d_m*tand(FOV/2);
    px_size=w/width;
end
