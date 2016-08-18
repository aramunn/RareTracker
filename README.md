# RareTracker
RareTracker observes when nearby units are created and checks their names against the achievements that require you to kill specific mobs.
Clicking on the names once a rare is found will show a quest hint arrow pointing you towards the mob.
If you have **TrackMaster** installed, it will also draw a line to the unit and allow you to track mobs at their last known location if they go out of range.

# Authors
* Tomed (Owner)
* Olivar Nax (Maintainer and Developer)

# Features in a nutshell
* **/raretracker**, **/rt** or walk near a rare mob to bring up the resizeable window.
* Access RareTracker settings through the Options side panel.
* Left click on a name to track it (use [TrackMaster](http://www.curse.com/ws-addons/wildstar/220025-track-master) to get tracking lines to track units that are out of range)
* Right click on a name to remove it from the list
* Red distance text means the unit was destroyed (dead or out of range), green means it's alive
* If a unit goes out of the configured range (see options), it will be automatically removed from the tracked mobs

# Screenshots
![empty tracker window](https://i.imgur.com/aG16w6O.png)
*empty tracker window*
![Config screen](https://i.imgur.com/sdUFEiE.png)
*Config screen*

# ChangeLog
* 2.2.1
	- Removing "Boss" or "World Boss" from the Rare Mob entries
* 2.2
    - RareTracker no longer tracks killed mobs by default. This can be changed in the options.
    - Tracked Rares are now based on the Achievements from API 12
