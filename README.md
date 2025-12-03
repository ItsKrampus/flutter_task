🍽 Flutter Meal App

This is a small Flutter app built for a technical task.
It pulls meal data from TheMealDB API, shows meal details, and also lets you create your own custom meals using Firebase Firestore.

Nothing fancy — just clean code, simple UI, and the required functionality.

IMPORTANT!
I Left the firebase keys in the repo on purpose for convinence since its a technical task I know .env exists!
API Didnt support crud operations so I implemented a firebase instance where you can create your own meals edit
them and delete them

✨ What the app does
🔍 1. Browse Meals (API)

Loads meals from TheMealDB

Shows a list with thumbnails + name + quick instructions preview

Has a search bar

Tapping a meal opens a detail page

📄 2. Meal Details Screen

Shows:

Thumbnail

Name

Category & area

Full instructions

Ingredients + measurements

Optional YouTube link

📝 3. Custom Meals (Firestore)

Users can:

Create a meal (name, category, area)

Edit a custom meal

Delete a custom meal

Data is stored in Firestore and updates live

A simple loading spinner is shown during create/edit/delete.

🛠 Tech Used

Flutter (Material 3)

Dart

Firebase Core

Firebase Firestore

HTTP package

url_launcher
