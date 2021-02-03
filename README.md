# nui_doorlock
A fork of esx_doorlock, featuring improved performance and improved functionality.
<hr>
<p align="center" style="font-size: 8pt; font-family: 'Tahoma';"><img src="https://i.imgur.com/wulspM9.png"/>
* Master represents the original; old is the code I created a fork from. *</p>
<hr>

* No more `SetEntityHeading` and `FreezeEntityPosition` natives.  
 Doors in range are assigned a doorHash, used with `AddDoorToSystem`.  
 Doors are assigned a state depending on if they are unlocked, locked, or locking with `DoorSystemSetDoorState`.  

* Garage doors and gates can be locked and will properly move into the correct position.  
If a player comes into range of an unlocked automatic door like this, it will open appropriately.  

* The state of the door is drawn into the world using NUI, meaning full customisation of the appearance and content.  
By default, icons from font-awesome are being displayed; but there is support for images with this method.  
Customisable sound playback! Modify the lock and unlock sound on a door-by-door basic.  

* Improved performance by utilising threads and functions where appropriate.  
Instead of updating the door list every X seconds, your position will be compared to where the last update occured and update when appropriate.  
The state of doors is only checked while in range, and the number of checks per loop depends on the state of the door.  

* Persistent door states! Door states are saved when the resource stops, then loaded back up on start.  
States.json will auto-generate if the file does not exist.  
When adding new doors to the config, you should delete states.json so a new one can be made.

<hr>
<p align="center">https://streamable.com/oheu5e  
<img src="https://i.imgur.com/Sug2Nj5.jpg"/></p>
