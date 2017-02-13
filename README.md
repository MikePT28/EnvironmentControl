# README #

###Environment control demo project.

The main goal of this project is to have just one build in your Adhoc share medium. To reduce the consumed space that comes as a side effect of having many environments in one app.
The idea is that with just one build you could switch between the different environments with relative ease.

##How is this project set up?

Right now the project consists on 2 targets: Release and CI (Continuous integration) -just like before on most projects-, and 5 schemas (this is the new part): Release, Test, Stage, Prod and Share.

###Why 5 schemas:

Well, the **Release** schema is the one that will be released to the AppStore and is linked to the **Release** target. This schema-target combo, **does not** include the setting bundle, and will always point to the *Production* environment.

Then we have **Test**, **Stage** and **Prod**, this 3 schemas are _shortcuts_ for developers. When one of this schemas is run from Xcode it will force the environment accordingly.

Finally we have the new schema **Share** this one is the one that is meant to be used for Share builds. This one does not force any environment, though it defaults to the testing environment.

###How do you force the shortcut environments?

This is done by using the **Environment Variables** of the schemas.
A new variable named "environment" is defined with an integer value of 0, 1 or 2. Each of those values correspond to an environment. Then on launch the Environment control object configures accordingly.

It is important to note that the Share schema **does not** implement this variable. This allows for the schema to remain dynamic when launching from Xcode.

###How do you notify the environment changed?

Right now there's a control property called: ***shouldForceRestart**. If this property is **true**, an alert view will be displayed on top of the window blocking further use of the app and requiring the app to be killed and restarted. Else, if the property is **false**, a notification is propagates and can be subscribed to from where needed.

###What else can it do?

For the time being there's not much else. Though a list of **TODO**s is being made and accepts suggestions from all.

#TODO:

- [ ] Make a TODO list.

#Why (or why not) should we use this?

It's is a complicated question to answer. 

The benefits from using this would be: 

1. Easier to change environments, no need to install a new build. 

1. Less space used on your Share drive, because we only need to have 1 build for all the environments. (This does not apply to test features that are not merged with the develop branch)

1. No need for MACROS (which are weird to use in swift for some reason)

1. Straight forward setup

The cons would be:

1. Might be trickier to explain to clients on how to use.

1. No use of MACROS, which means everything is compiled. (Though is not necessarily true. MACROS can be used across the app just not to define the environments)
