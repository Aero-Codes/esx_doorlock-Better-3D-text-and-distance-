# [thelindat] esx_doorlock

Now checks for doors set in config and assigns text coordinates automatically.  
Ignores doors that are not in range.  
Seperated entityfreeze and control check to reduce functions being performed.  
Doors will lock once the door swing is complete.  
Support for sliding doors (gates).  
Improved cpu usage.





## [ORIGINAL] esx_doorlock-Better-3D-text-and-distance-

This esx_doorlock got better 3D text and distance check, unlike old esx_doorlock even you are far away from doors gives 0.20-0.30ms

Optimized esx_doorlock (distance and 3D Text)
-0.1ms if far away from doors (Stable)
-0.30ms if near door
-Better 3D Text
-With Animation when unlocking and locking doors

Old esx_doorlock
-if far away from doors (gives 0.20ms+)
