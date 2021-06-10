
# Mamo

  
<div  align="left">

<!-- Swift version -->

<img  src="https://img.shields.io/badge/swift%20version-5.0-brightgreen.svg"  alt="swift version">

<!-- Platform -->

<img  src="https://img.shields.io/badge/platform-ios-lightgrey.svg"  alt="platform" />

</div>

# App Features
- [x] Access Contacts 
- [x] Display Frequent Receivers, Mamo Accounts and Local contacts  
- [x] Display contact details 
- [x] UnitTest

  

## Architecture

This project is using Clear architecture+ MVVM pattern where:

 - Network layer to deal with remote data base and handel all backend errors 

# Data Layer 
 - Repository design pattern to abstract how the data is being retrieved  
 - Entities are DTO (Frequents and Mamo Accounts) transfer data to object. 

# Domain layer 
- Interactor to seprate business logic then construct presentation object to Presentation Layer 

# Presentation layer 
- View is represented by `UIViewController` designed in Storyboard

- **ViewModel** interacts with ViewStateModels and prepares data to be displayed. View uses ViewModel's data either directly or through **bindings (using Combine)*** to configure itself. View also notifies ViewModel about user actions.
- **Builder** is the key for reusability, declares what data is needed for the Module to be built, **injects**
- Coordinator for handling navigation using router which abstract navigation functions 



## Requirements

- Xcode Version 12.5

- Swift 5.0+

- iOS 13.4+