# pomodo

A new Flutter project.

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

#### General

- [x] Base project structure (+30min)
- [x] Add logger (+5min)
- [ ] Add main FlutterError.onError
- [ ] Add main runZonedGuarded
- [ ] Add i18n with slang package

#### Features

- [x] Create Project, Section and Task model (+30min)
  - [x] Create models test
- [x] Create Project, Section and Task datasource (+3h)
  - [x] Tests for each datasource implementation
  - [x] Connect with developer todoist for Project endpoints integration tests
  - [x] Add environment variable for test token
- [x] Create Task comment datasource
- [ ] Create Project repository
  - [ ] Create repository test
  - [ ] Add to global app repositories
- [ ] Create Tasks BLoC
  - [ ] Create tests
  - [ ] Get tasks
  - [ ] Add task
  - [ ] Close task
  - [ ] Start task timer
  - [ ] Update task time (maybe)
  - [ ] Filter tasks

#### UI

- [ ] Tasks Home screen
  - [ ] Task To Do, In Progress, Done tabs
- [ ] Create task screen
  - [ ] Edit task screen (flagged screen)
- [ ] Task bottom modal
- [ ] Task tracking time screen
- [ ] Splash screen

#### Outro

- [ ] Add application videos to README
- [ ] Add application icon, name and signature

#### Extra

In case there's extra time remaining, implement the following in order of priority/easier

- [ ] Dark theme
- [ ] Local notifications
- [ ] Offline feature
  - [ ] Caching, or;
  - [ ] Offline first
- [ ] Implement GitHub CI/CD
- [ ] Feature:
  - [ ] User can create/rename/delete more than one project
