<p align="left" style="font-size: 22pt; font-family: 'Times New Roman'; font-weight: 600; line-height:15pt;">nui_doorlock</br>
<font style="font-size: 9pt; font-family: 'Tahoma'; font-weight: 500;">A fork of esx_doorlock, featuring improved performance and improved functionality.</font>
<hr></p>
<p align="center" style="font-size: 8pt; font-family: 'Tahoma';"><img src="https://i.imgur.com/wulspM9.png"/>
* Master represents the original; old is the code I created a fork from. *</p>
<hr>
<font style="font-size: 9pt; font-family: 'Tahoma'; font-weight: 500;">
<ul>
<li>No more `SetEntityHeading` and `FreezeEntityPosition` natives.<br>
Doors in range are assigned a doorHash, used with `AddDoorToSystem`.<br>
Doors are assigned a state depending on if they are unlocked, locked, or locking with `DoorSystemSetDoorState`.
</li><br>
<li>Garage doors and gates can be locked and will properly move into the correct position.<br>
If a player comes into range of an unlocked automatic door like this, it will open appropriately.
</li><br>
<li>The state of the door is drawn into the world using NUI, meaning full customisation of the appearance and content.<br>
By default, icons from font-awesome are being displayed; but there is support for images with this method.
</li><br>
<li>Improved performance by utilising threads and functions where appropriate.<br>
Instead of updating the door list every X seconds, your position will be compared to where the last update occured and update when appropriate.<br>
The state of doors is only checked while in range, and the number of checks per loop depends on the state of the door.</li>
</ul>
</font><hr>
<p align="center" style="font-size: 8pt; font-family: 'Tahoma';"><img src="https://i.imgur.com/Sug2Nj5.jpg"/></p>
