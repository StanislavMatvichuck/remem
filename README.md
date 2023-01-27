# Remem

### Domain model description

An `Event` can be added by providing `name`

A `Happening` can be added to `Event` at certain `dateTime`

Existing `Happening` can be removed from `Event`

Existing `Event` can be deleted

Existing `Event` can be renamed

### Application description

WHEN application is launched `EventsList` screen is shown

WHEN `Create Event` button is tapped `EventInput` is shown

WHEN `Emoji` is tapped it is added to `name`
  
WHEN `Cancel` button is tapped
 
OR area above `Emojis container` is tapped
 
THEN `EventInput` is hidden

WHEN `EventInput` is submitted

OR `Create event` button is tapped

THEN `Event` is added to `EventsList` as `EventItem` with specified `name`

`EventItem` shows `Event` name and sum of `Happening`s for today

WHEN `EventItem` is swiped from left to right a `Happening` is added to corresponding `Event`

WHEN `EventItem` is swiped from right to left `Delete` and `Rename` buttons are shown

WHEN `Delete` button is tapped `EventItem` is removed from `EventsList`

WHEN `Rename` button is tapped `EventInput` is shown
  
AND `EventInput` name is configured
  
AND `Rename` button is shown instead of `Create event`

WHEN `Rename` button is tapped

OR `EventInput` is submitted

THEN existing `Event` is renamed

WHEN `EventItem` is tapped `EventDetails` screen is shown

`EventDetails` shows `Week` AND `Clock` AND `Stats` and title is `Event`s name

### Atlas for light mode

![Atlas for light mode](/Tests/Snapshots/Images_64/Atlas/test05_eventsListBasicFlow@2x.png)

### Atlas for dark mode

![Atlas for dark mode](/Tests/Snapshots/Images_64/Atlas/test06_eventsListBasicFlow_dark@2x.png)
