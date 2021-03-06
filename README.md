# Project Elevate
[![Maintainability](https://api.codeclimate.com/v1/badges/8e4ebf79eb7e18659120/maintainability)](https://codeclimate.com/github/zdehkordi/Project-Elevate/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8e4ebf79eb7e18659120/test_coverage)](https://codeclimate.com/github/zdehkordi/Project-Elevate/test_coverage)
[![Build Status](https://travis-ci.org/zdehkordi/Project-Elevate.svg?branch=master)](https://travis-ci.org/zdehkordi/Project-Elevate)

Find the live app: [https://project-elevate-2.herokuapp.com](https://project-elevate-2.herokuapp.com)

Project Elevate is a website that is meant to help sports clubs create a system where athletes and coaches can log in and track their lessons, payments, and memberships. awef

## Software
* Ruby 2.5.3
* Rails 5.2.2

## Features

### Calendar Events
* Track and show club events
* Track and show personal events, such as lessons
* Ability to edit and create additional events

### Lesson Booking
The booking system is broken down between a coach's perspective and a player's perspective.  
For the coach's perspective we designed the following:  
* Ability to add/edit/delete a coach's available times throughout the week
* Ability for a coach to view his/her specific booked lessons on the calendar

For the player's perspective we designed the following:
* Book a single lesson
* Book recurring lessons in bulk as a package
* Ability to view any and all booked lessons on the calendar
* Ability to choose a specific coach and date for a lesson
* Have the player pay via Stripe to confirm the booking

Booking lessons in bulk allow for the capability of having certain lessons overlap and conflict since you are signing up for a recurring weekly time.  
However, users are notified of any conflicting lessons and administrators are given the privilege of viewing and editing any events in order to resolve any conflicts.  
Packages determine how many bulk lessons a member can book at one and how much the bulk lessons cost, and can only be determined by an administrator.  

### Membership
The membership was broken down into 3 primary categories: Member, Coach, Administrator  

All categories of membership are capable of the following:  
* Editing their user name/password/email
* Viewing their personal calendar with personal events along with any club events that affects everyone

A member is capable of the following:
* Booking a single lesson
* Booking recurring lessons in bulk

A coach has the extra capabilities:
* Add/Delete/Edit their availabilities

An administrator has the extra capabilities:
* Elevate/De-elevate the status of any member in the club/organization to a different membership status
* View the calendars of other members in the organization
* Add calendar events that affect everyone in the club
* Edit calendar events to resolve conflicting events
* Creating packages for bulk lessons and determining the prices

When signing up for a new account, the account will initially start off with a Member status.  
In order to change one's membership status to coach, they must get the approval and actions of an administrator.  
Currently only one administrator account exists within the database.  

### Dashboard
Currently both Students and Coaches have a Dashboard which contains the following details:
#### Student Dashboard
* History of which Coaches a Student trained with
* Number of Classes a Student has completed
* Number of Classes a Student has Scheduled
* Total Money Spent on Classes
* List of Upcoming Classes
#### Coach Dashboard
* History of which Students a Coach has trained
* Number of Classes a Coach has Taught
* Number of Classes a Coach has been scheduled to Teach
* Total Money Made on Classes
* List of Upcoming Classes


## Deployment
Currently the website is deployed via heroku and can be accessed at https://project-elevate-2.herokuapp.com/

## Setting Up and Testing Locally
In order to run a local version of this app, make sure to have bundler installed.

Run the following commands in the Project-Elevate directory:
```
bundle install --without production
```
This will properly version control any files along with gems in order to properly run the app locally on your environment.

```
rails db:reset
rails db:migrate
rails s
```
This will clear any pre existing possible data in the rails database and seed the rails server with the seeded data before starting up the server.
This is crucial for testing any administrator privileges as there is no other way to create an administrator account currently. The server should be running locally on default port 3000, or whichever specified port using the -p tag.  

## Encryption and Keys
The only API Keys used in this Project are Published and Secret Keys for stripe: https://stripe.com/. To generate a new set of test keys follow this guide by Stripe: https://stripe.com/docs/keys. Once the new keys are generated; make sure to generate a new credentials and master.key file to implement the new keys.
### In order to setup a new credentials and master.key follow this guide
Run the following commands in the Project-Elevate directory:
```
rm config/credentials.yml.enc
```
This will remove the old credentials file.
```
EDITOR=vim rails credentials:edit
```
This will generate a new `credentials.yml.enc` and `master.key` -> Keep the `master.key` safe!
In the editor for the credentials file add the code below with the new keys:
```
publish_key_stripe: YOUR_KEY_HERE
secret_key_stripe: YOUR_KEY_HERE
```
Everything is now setup for development!

## Logins

Admin Login:
* email: **matthew.sie@berkeley.edu**
* password: **dabaka22**

Coach Login:
* email: **rogerahh@gmail.com**
* password: **12345678**

## Testing

Lastly, in order to view coverage and tests run
```
cucumber
```
or
```
rspec
```
A separate coverage folder will be created where you can view files independently, or you can view the separate tests created in each of the respective folders.

## Note
Original App Name: [https://project-elevate.herokuapp.com/](https://project-elevate.herokuapp.com/)
Once original Heroku Credentials are found; switch to this herokuapp.
