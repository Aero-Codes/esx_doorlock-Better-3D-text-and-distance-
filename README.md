# [thelindat] esx_doorlock

Now checks for doors set in config and assigns text coordinates automatically.  
Ignores doors that are not in range.  
Seperated into three threads to reduce number of functions being performed.   
Doors will lock once the door swing is complete.  
Support for sliding doors (gates).  
Improved cpu usage.  
Animation when interacting with doors.  


## Comparison  
Master = Original release of esx_doorlock  
Old = Code I started working from  

Standing away from doors  
<img src='https://i.imgur.com/OMZ5Ou6.png'/>

Standing near an unlocked door (with 'Unlocked' text display)  
<img src='https://i.imgur.com/mFPFy79.png'/>

Standing near a locked door (with 'Locked' text display)  
<img src='https://i.imgur.com/jolLuRg.png'/>




## [OLD] esx_doorlock-Better-3D-text-and-distance-

This esx_doorlock got better 3D text and distance check, unlike old esx_doorlock even you are far away from doors gives 0.20-0.30ms

Optimized esx_doorlock (distance and 3D Text)
-0.1ms if far away from doors (Stable)
-0.30ms if near door
-Better 3D Text
-With Animation when unlocking and locking doors

Old esx_doorlock
-if far away from doors (gives 0.20ms+)
