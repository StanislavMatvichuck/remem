# Remem

Hello. You are looking at Remem repository, which is a project that I started at the beginning of 2022 to improve my knowledge in ios development. Along this way I discovered a lot of conceptions and development practices one can use to make reliable software. These include unit testing, integration testing, domain modeling, applying SOLID principles and Pure dependencies injection. To be specific, here is a list of books that were used as sources of knowledge:

[IOS Unit testing by example, Jon Reid](https://www.amazon.com/iOS-Unit-Testing-Example-Techniques/dp/1680506811)

[Dependency Injection Principles, Practices, and Patterns, Mark Seeman](https://www.amazon.com/Dependency-Injection-Principles-Practices-Patterns/dp/161729473X)

[Domain Driven Design, Erik Evans](https://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215)

[Clean Code, Robert Martin](https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)

[IOS Core Animation Advanced techniques, Nick Lockwood](https://www.amazon.com/iOS-Core-Animation-Advanced-Techniques-ebook/dp/B00EHJCORC)


I did some web and cross-platform development using react-native and javascript previously and I always felt that strongly typed languages like Swift or Java demand more of a computer science understanding but provide scalability and higher performance. What I didn’t expect to find is DDD. This approach seems to be very powerful so I decided to put it in practice immediately. Any software project alive must evolve and grow in time so please **feel free to add anything you would like to see as functionality** or concept to issues section. Any code improvement suggestions welcomed too.

## Planned features list

- [ ] **Volume tests.** Would be cool to prove mathematically that application will behave seamlessly even after 5-10 years of usage.
- [ ] **Weekly goal.** Having a setup goal allows to track and display the amount of progress towards it. (wip)
- [x] **PDF reports.** This will allow to share your achievements with others with ease. (wip)
- [x] **Events list sorting variants.** List is static which blocks user from any customisations and convenient widget usage. (wip)
- [ ] **Fancy animated screenshots in store.** During day details interactive transition prototyping I realized that it is quite possible to add a bit of movement to store description with animations. I use [Blender Editor](https://www.blender.org) to create objects in 3D to animate them quickly and make a "movie" that serves as a reference during animation setup in code.

## Download for ios
https://apps.apple.com/ua/app/remem-counting/id1613756077

## Quick demo
https://user-images.githubusercontent.com/4983331/226573512-10b9c7ae-cfdb-411b-83ff-75b00c0cf3bb.mp4

## Atlases produced by snapshot tests. It is production code with test data.

![Atlas for light mode](/Tests/Snapshots/images_en_64/iphonese(3rdgeneration)/light/ZAtlas/test05_eventsListBasicFlow.png)
Dark mode

![Atlas for dark mode](/Tests/Snapshots/images_en_64/iphonese(3rdgeneration)/dark/ZAtlas/test06_eventsListBasicFlow_dark.png)
Ukrainian localization

![Atlas for Ukrainian localization](/Tests/Snapshots/images_ua_64/iphonese(3rdgeneration)/light/ZAtlas/test05_eventsListBasicFlow.png)
German localization

![Atlas for German localization](/Tests/Snapshots/images_de_64/iphonese(3rdgeneration)/light/ZAtlas/test05_eventsListBasicFlow.png)
Russian localization

![Atlas for Russian localization](/Tests/Snapshots/images_ru_64/iphonese(3rdgeneration)/light/ZAtlas/test05_eventsListBasicFlow.png)


## Domain model description

An `Event` can be added by providing `name`

A `Happening` can be added to `Event` at certain `dateTime`

Existing `Happening` can be removed from `Event`

Existing `Event` can be deleted

Existing `Event` can be renamed
