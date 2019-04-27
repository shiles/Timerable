# Pomodoro
An iOS app written in Swift. The goal is to create a configurable pomodoro method timer to aid me in focusing when I study. The goal of this project is to learn how to develop an iOS application, from the design to the deployment to the applestore.

## Features:

Feature | Explanation
------------ | -------------
Timer | A configurable *pomodoro timer* to allow the user to schedule a working session under a subject and work with both short and long breaks to study effectively.
Autolayout | *Autolayout* has been used throughout the UI to create an app that will scale to any of the current iPhone models well.
Notifications |  *UserNotifications* allow the app to be backgrounded without any impact on battery life, the app will fast forward when its brought back into the foreground. When the app is on screen an audio notification is used as an alternative to the notifications.
Graphed Statistics | Add a graph that filers by the last 7 days to show how much you've been working each day that week to help visualise how you're studying. 


## Future Roadmap: 

Feature | Explanation
------------ | -------------
Study Goals | Add daily/weekly study targets to help motivate the user to study and complete their work.
Watch App | A supplimentary watch app that'll allow you to look at the current time of your session and allow you to pause and resume for unexpected breaks that may need to be taken.
iPad App | Port the visuals and the codebase to an iPad app since studying isn't always done on the same device. This would include syncing the *CoreData* model across the users iCloud account.
