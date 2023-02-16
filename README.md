# Remem

⚠️ Repository description is under active construction :)

Planned features list

- [ ] **Volume tests.** Would be cool to be sure that application will behave seamlessly even after 5-10 years of usage.
- [ ] **Weekly goal.** Having a setup goal allows to track and display the amount of progress towards it.
- [ ] **PDF reports.** This will allow to share your achievements with others with ease.
- [ ] **Events list sorting variants.** List is static which blocks user from any customisations.

https://user-images.githubusercontent.com/4983331/218532749-147d6536-195b-479b-aa86-b9bcbcc3464c.mp4

<details>
  <summary>Domain model description</summary>

An `Event` can be added by providing `name`

A `Happening` can be added to `Event` at certain `dateTime`

Existing `Happening` can be removed from `Event`

Existing `Event` can be deleted

Existing `Event` can be renamed
  
</details>


<details>
  <summary>Описание предметной модели</summary>

`Событие` может быть создано, используя `название`

`Происшествие` может быть добавлено к `Событие` в определенное `датаВремя`

Существующее `Происшетвие` может быть удалено из `События`

Существующее `Событие` может быть удалено

Существующее `Событие` может быть переименовано
  
</details>

<details>
  <summary>Application description</summary>

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

</details>

[Atlas for light mode](/Tests/Snapshots/images_en_64/ZAtlas/test05_eventsListBasicFlow_375x667.png)

[Atlas for dark mode](/Tests/Snapshots/images_en_64/ZAtlas/test06_eventsListBasicFlow_dark_375x667.png)

[Atlas for Ukrainian localization](/Tests/Snapshots/images_ua_64/ZAtlas/test05_eventsListBasicFlow_375x667.png)

[Atlas for German localization](/Tests/Snapshots/images_de_64/ZAtlas/test05_eventsListBasicFlow_375x667.png)

[Atlas for Russian localization](/Tests/Snapshots/images_ru_64/ZAtlas/test05_eventsListBasicFlow_375x667.png)
