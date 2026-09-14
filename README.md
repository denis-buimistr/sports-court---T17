SportsCourt — Sports Court Booking App

Course: PAM (Programarea Aplicațiilor Mobile / Mobile Application Programming) Student: Buimistr Denis Group: CR-233 Platform: iOS (Flutter / Dart) + Backend (Java / Spring Boot)

Topic

SportsCourt is a mobile application that helps amateur teams and casual players book football, tennis and basketball courts around the city. It shows a list of available venues with hourly pricing, lets users check free time slots by day, and place a booking with instant confirmation or cancellation.

Today, booking a court usually means calling the venue administrator directly, hoping the slot you want is still free, and often ending up with double bookings or wasted trips. SportsCourt puts the whole process — browsing, checking availability and confirming — directly in the user's hands.

Problem
There is no single place to compare courts, prices and availability across venues.
Checking free time slots requires a phone call or a visit, which is slow and unreliable.
Double bookings happen when two people call at the same time and both get verbal confirmation.
Regular players (weekly teams) have no easy way to track their upcoming and past reservations.
Solution — main features
Authentication — sign up and log in to manage personal bookings.
Court list — search and filter venues by sport type and district.
Court details — photos, price per hour, amenities and location.
Time slot picker — choose a day and see which hours are still free.
Booking confirmation — review a summary (court, date, time, price) before confirming.
My bookings — upcoming and past reservations, with the option to cancel.
User profile — personal info and account settings.
Bonus (planned): recurring weekly bookings, inviting teammates to a booking, courts shown on a map.
Planned screens
Screen	Purpose
Login / Register	Create an account or sign in
Court List	Search and filter courts by sport and district
Court Details	Photos, price per hour, amenities
Time Slot Selection	Pick a day and an available hour
Booking Confirmation	Review and confirm the reservation
My Bookings	Upcoming and past reservations, cancellation
Profile	Personal user information
Technology stack

Frontend

Flutter (Dart) — cross-platform UI framework, primary target iOS
Xcode / iOS Simulator — build and run on macOS
go_router — navigation between screens
State management: Provider / Riverpod (to be decided during development)
Local data layer: Repository pattern with mock data before backend integration

Backend

Java + Spring Boot — REST API
Spring Data JPA — persistence layer
PostgreSQL — database
Spring Security + JWT — authentication
Entities: Court, TimeSlot, Booking, User

Tooling

IDE: IntelliJ IDEA (backend) + VS Code / IntelliJ with Flutter plugin (frontend)
Version control: Git / GitHub
Origin

The project is developed as an incremental, cross-lab assignment: starting from a set of static screens, the same application is progressively extended with navigation, state management and, finally, a real backend built from scratch, matching the requirements of the PAM course.

Roadmap
 Choose topic, describe the idea (this README)
 Set up Flutter project and iOS build
 UI: Court List and Court Details screens
 Time Slot and Booking Confirmation screens
 Local data layer (Repository + mock data)
 Backend: Spring Boot REST API + database
 Backend integration, JWT authentication
 Offline cache, testing, release build
