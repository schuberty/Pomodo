<h1 align="center">Pomodo</h1>

<div align="center">

Pomodo (Pomodor + ToDo) is a mobile application made with Flutter for a case study and test.

[![Flutter SDK Badge](https://img.shields.io/badge/SDK-Flutter-blue)](https://flutter.dev/docs)

</div>

This application was made with Flutter using BLoC, and some other minimal packages.

To run the app you need a todoist test token, that can be obtainable via the console at the [todist developer website](https://developer.todoist.com/), and run the application with your desired commands and a dart define flag, for example:

> flutter run --release --dart-define TODOIST_API_TEST_TOKEN=$TODOIST_TEST_TOKEN

If you wish to easily update the project dependencies, just run the script [scripts/refresh_project_pub.sh](./scripts/refresh_project_pub.sh), that it'll updated any dart pub dependencie necessary and build the application localization files.

Where `$TODOIST_TEST_TOKEN` is the previously mentioned token.

Other than that you can run the application tests using a helper script located at [scripts/run_tests.sh](./scripts/run_tests.sh), which depending on the test (unit or integration) you'll also need the test token.

# MVP Development

## App data flow

#### Initial data retrieve

1. Get all Projects
   1. Check if has parent project named "pomodo_app"
      1. If has, return its data and ID
      2. Otherwise, create and do step above
   2. Filter all projects that have the parent ID of above
   3. Pass filtered projects
2. Get all Sections
   1. Filter Sections based on projects IDs
   2. Check if has TODO, PROGRESS and DONE sections
      1. If has, return its data and ID
      2. Otherwise, create missing sections and do step above
3. Get all Tasks
   1. Filter each Task if it's a child project of the "pomodo_app" project ID
   2. Add each Task to each project, in each section with both having the same ID

#### Tracking time

Each Task has a description field, at the end of the description field there's a tag as:

> <pomodo_app:time_ms:0>

Where zero is the duration in seconds of how long the task has being tracked for, as the API doesn't have a metadata option, this was the alternative.

## Progress tracking

#### Schedule

Where monday is 08/07 and friday 12/07.

| Weekday      | mon | tue | wed | thu | fri |
| ------------ | --- | --- | --- | --- | --- |
| Availability | x   |     |     | x   | x   |

#### Total time

The total time focused in the project (average of bellow tasks) was around 30.6 hours.

##### General

- [x] Base project structure (+30min)
- [x] Add logger (+5min)
- [ ] Add main FlutterError.onError
- [ ] Add main runZonedGuarded
- [x] Add i18n with slang package (+30m)

#### Features

- [x] Create Project, Section and Task model (+30min)
  - [x] Create models test
- [x] Create Project, Section and Task datasource (+3h)
  - [x] Tests for each datasource implementation
  - [x] Connect with developer todoist for Project endpoints integration tests
  - [x] Add environment variable for test token
- [x] Create Task comment datasource (+1h)
- [x] Create Project repository (+3h)
  - [x] Create repository test
  - [x] Add to app providers
- [x] Create Project store (+2h)
- [x] Create Tasks cubit (+3h)
  - [x] Create tests
  - [x] Get tasks
  - [x] Add task
  - [x] Move tasks
  - [ ] Close task
  - [x] Start task timer
  - [ ] Update task time (maybe)
  - [ ] Filter tasks
- [x] Added Task timer (+5h)
  - [x] Start timer
  - [x] Listen to timers update
  - [x] Stop timer
  - [ ] Save timer data periodically
- [ ] History of completed tasks
- [ ] Task comment
- [ ] Better error messages

#### UI

- [x] App styling and assets (+2h)
- [x] Tasks Home screen (+3h)
  - [x] Task To Do, In Progress, Done tabs
- [x] Create task screen (+6h)
  - [x] Connect task screen with states
  - [x] Edit task screen (flagged screen)
- [x] Task bottom modal (+30m)
- [x] Task tracking time modal screen (+30m)
- [ ] Splash screen
- [ ] Home bottom tab page with history of completed tasks
  - [ ] Make use of StatefulShellRoute with indexed stack from Go Router
- [ ] Task comment flow in task details modal

#### Outro

- [ ] Add application videos to README
- [ ] Add application icon, name and signature

#### Extra

In case there's extra time remaining, implement the following in order of priority/easier

- [ ] Dark theme
- [ ] Skeleton loading animation
- [ ] Local notifications
- [ ] Implement GitHub CI/CD
- [ ] Offline feature
  - [ ] Caching, or;
  - [ ] <s>Offline first</s>
- [ ] Feature:
  - [ ] User can create/rename/delete more than one project
