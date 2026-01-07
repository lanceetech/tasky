# Task Management App Blueprint

## Overview

This document outlines the plan for building a full-featured task management application. The app will allow users to create, manage, and track their tasks effectively. The user interface will be modern, intuitive, and responsive, ensuring a seamless experience on both mobile and web platforms.

## Style, Design, and Features

### Version 1.0 (Initial)

*   **UI/UX:**
    *   Modern and clean design following Material Design 3 principles.
    *   A vibrant color scheme with a primary seed color.
    *   Consistent typography using the `google_fonts` package.
    *   Support for both light and dark themes, with a toggle to switch between them.
    *   Responsive layout for different screen sizes.
*   **Core Features:**
    *   **Task Model:** A `Task` class with `id`, `title`, and `isDone` properties.
    *   **State Management:** Using the `provider` package for managing the list of tasks.
    *   **Task Operations:**
        *   Add new tasks.
        *   Edit existing tasks.
        *   Delete tasks.
        *   Mark tasks as complete or pending.
    *   **Filtering:** A tab bar to filter tasks by "All", "Pending", and "Completed" status.
    *   **Data Persistence:** Tasks will be stored in memory for the initial version.

### Version 2.0 (Timers and UI Enhancements)

*   **New Features:**
    *   **Task Timers:**
        *   Users can set a duration for each task.
        *   A countdown timer is displayed for each task.
        *   Users can start, pause, and reset timers.
*   **UI/UX Enhancements:**
    *   **Card-based UI:** Tasks are displayed on `Card` widgets with a subtle drop shadow for a "lifted" feel.
    *   **Animations:** Smooth animations for adding and removing tasks.
    *   **Enhanced Interactivity:** Interactive elements have a "glow" effect.
    *   **Improved Typography:** Better use of font sizes to create a visual hierarchy.
    *   **Vibrant Color Scheme:** An updated color palette for a more energetic look.
    *   **Background Texture:** A subtle noise texture on the main background.
    *   **Icons:** More use of icons to improve usability.

### Version 3.0 (Data Persistence)

*   **Core Logic:**
    *   Integrate the `hive` database for local data storage.
    *   Tasks will be saved to and loaded from the device, so data persists between app sessions.
    *   Modify the `Task` model to be compatible with `hive`.
    *   Refactor the `TaskProvider` to interact with the `hive` database.

### Version 4.0 (Advanced UI Enhancements)

*   **UI/UX Enhancements:**
    *   **Circular Progress Timer:**
        *   Each task item now features a circular progress indicator that visually represents the remaining time.
        *   The indicator is overlaid on the task card for a modern, integrated look.
        *   The color of the progress indicator dynamically changes from green to red as the timer approaches zero, providing an immediate visual cue of the task's urgency.
    *   **Active Timer Glow Effect:**
        *   When a timer is actively running, the circular progress indicator emits a subtle, pulsing glow.
        *   This effect, created with `flutter_animate`, draws the user's attention to the active task and makes the interface more dynamic and engaging.

## Current Plan: UI Iteration

The latest iteration focuses on enhancing the visual feedback and interactivity of the task items. The addition of the circular progress indicator and the active timer glow provides a more intuitive and aesthetically pleasing user experience. The next steps will involve further refinement of the UI and potentially adding more animations and micro-interactions.
