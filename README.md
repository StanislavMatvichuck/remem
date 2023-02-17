# Remem

Hello. You are looking at Remem repository, which is a project that I started at the beginning of 2022 to improve my knowledge in ios development. Along this way I discovered a lot of conceptions and development practices one can use to make reliable software. These include unit testing, integration testing, domain driven development, applying SOLID principles. I did some web and cross-platform development using react-native and javascript previously and I always felt that strongly typed languages like Swift or Java demand more of a computer science understanding but provide scalability and higher performance. What I didn’t expect to find is DDD. This approach seems to be very powerful so I decided to put it in practice immediately. Any software project alive must evolve and grow in time so please **feel free to add anything you would like to see as functionality** or concept to issues section. Any code improvement suggestions welcomed too.

## Planned features list

- [ ] **Volume tests.** Would be cool to be sure that application will behave seamlessly even after 5-10 years of usage.
- [ ] **Weekly goal.** Having a setup goal allows to track and display the amount of progress towards it.
- [ ] **PDF reports.** This will allow to share your achievements with others with ease.
- [ ] **Events list sorting variants.** List is static which blocks user from any customisations.

## Download for ios
https://apps.apple.com/ua/app/remem-counting/id1613756077

## Quick demo
https://user-images.githubusercontent.com/4983331/218532749-147d6536-195b-479b-aa86-b9bcbcc3464c.mp4


## Domain model description

An `Event` can be added by providing `name`

A `Happening` can be added to `Event` at certain `dateTime`

Existing `Happening` can be removed from `Event`

Existing `Event` can be deleted

Existing `Event` can be renamed

## Atlases produced by snapshot tests. This is production code with test data.

[Atlas for light mode](/Tests/Snapshots/images_en_64/ZAtlas/test05_eventsListBasicFlow_375x667.png)

[Atlas for dark mode](/Tests/Snapshots/images_en_64/ZAtlas/test06_eventsListBasicFlow_dark_375x667.png)

[Atlas for Ukrainian localization](/Tests/Snapshots/images_ua_64/ZAtlas/test05_eventsListBasicFlow_375x667.png)

[Atlas for German localization](/Tests/Snapshots/images_de_64/ZAtlas/test05_eventsListBasicFlow_375x667.png)

[Atlas for Russian localization](/Tests/Snapshots/images_ru_64/ZAtlas/test05_eventsListBasicFlow_375x667.png)
