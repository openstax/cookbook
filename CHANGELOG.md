# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

* Changes `default_css_or_xpath` to optionally be a proc to be evaluated w.r.t. a document's config (minor)
* Support namespaces defined on elements other than the root (minor)
* Non-splash figures now treated like normal intro-body content in `BakeChapterIntroductions`
* `BakeNumberedNotes` and the uphysics strategy for `MoveSolutionsToAnswerKey` updated to accomodate multiple exercises in a note.
* `BakeFootnotes` now looks for footnotes in composite chapters
* Move exercise pantry label storage to `BakeNumberedExercises` to ensure consistency between exercise number and link text
* Update `BakeIndex` term capitalization handling to be less case sensitive (minor)
* Added a title tag variable to choose between h2 and h3 for children of chapter review (minor)
* Added a fix for examples not to bake table captions (minor)
* Replaced a .text with .children to include math text (minor)
* Changed title tag on numbered notes to always be h3 (major)
* Storing all note subtitles in the pantry for link placeholders (minor)
* Added another xmlns string option to remove if clone (minor)
* Add class to reference superscript & add metadata to `BakeSuggestedReading` (minor)
* Add `BakeFreeResponse` Directions (minor)
* Add terms from composite pages to index (minor)
* Access `.pantry` and `.clipboard` through an element instead of just its document (minor)
* Add `suppress_solution` option to `BakeNumberedExercise` (minor)
* Add strategy for American Government answer key (minor)
* Add `BakeReferences` direction (minor)
* Fix xmlns string replacement done in PR #209 (minor)
* Move title above metadata in `BakeSuggestedReading` direction (major)
* Remove depreciated directions `BakeNotes` and `BakeExercises` (major)
* Adds `eoc_composite_metadata_title` to en.yml and eoc template (major)
* Add `template` folder to kitchen to hold templates (minor)
* Add `eoc_section_title_template` (minor)
* Expand specs with `append_to` to have with/without `append_to` contexts (minor)
* Add `is?` method to `ElementBase` (minor)
* Replaced in_composite_chapter to use `is?` (minor)
* Add callable `short_type` to Elements (minor)
* Add template for eob titles - `eob_section_title_template` (minor)

## [3.2.0] - 2021-04-19

* Adds method to allow unit and page title text to be retrieved regardless of bake status (minor)
* Rename several directions (major)
  * `BakeChapterReviewExercises` -> `MoveExercisesToEOC`
  * `BakeChapterReview` -> `ChapterReviewContainer`
  * `BakeBookAnswerKey` -> `BookAnswerKeyContainer`
  * `BakeChapterAnswerKey` -> `MoveSolutionsToAnswerKey`
* Refactors `BakeFirstElements` and `BakeNumberedExercise` (minor)
* Adds a decorating option of equation numbers on `BakeEquations` (minor)

## [3.1.0] - 2021-04-19

* Add the ability to copy an element's ID to `ElementBase` (minor)
* Create `pl.yml` and add pl to available locals in `StubHelpers` module (minor)
* Add to `BakeNumberedNotes` directions for baking exercises in a note (with this comes removing bake checkpoints and theorems)
* Add `BakeEquations` direction (minor)
* Remove `NoteElement` logging (minor)
* Adds `BakeChapterReviewExercises` v2 and a u-physics `Strategy` to `BakeChapterAnswerKey` to support baking exercises in u-physics (minor)
* Have deprecated directions log a warning (minor)
* Added `wrap_children` method on elements (minor)
* Refactored `NoteElement` to infer the note title from book-specific locales (minor)
* Added support for a recipe to infer or be given a book-specific locale file (minor)
* Added `NumberedTable` support for titles and always captions (minor)
* Added titles method to `ElementEnumeratorBase` and `ElementBase` (minor)
* Added a file for baking composite chapters called (`bake_composite_chapters`) and the respective spec.
(minor change)
* Added `BakeProblemFirstElements` direction (minor)

## [3.0.0] - 2021-03-17

* Added a subfigure? method to `FigureElements`(minor)
* Added support for titles in `BakeFigure` (minor)
* Created `BakeUnitTitle` class
* Created `UnitElement` and `UnitElementEnumerator` classes (minor)
* Added support for Units in `BakeToc` direction (minor)
* Added `Unit` to `en.yml` (patch)
* Remove chapter summary titles only if they exist (minor)
* Created `BakeSuggestedReading` direction for EOC
* Added ability to filter searches based on `only` and `except` conditions, which can be names of element methods or blocks of code (minor)
* Changed from tracking and using `css_or_xpath` strings and arrays to `search_query` objects that
  wrap `css_or_xpath` variables along with `only` and `except` conditions. (major?)
* Refactored bake_exercises to better support parallel work on multiple versions. (minor)

## [2.0.0] - 2020-12-18
* Added a file for baking key concepts called (`bake_chapter_key_concepts`) and the respective specs.
(minor change) only affects the book if called from the recipe
* Changed the main gem source file to have the same name as the gem (`openstax_kitchen`) so that you don't have to `require` a different name than you use in your `gem` call.

## [1.0.0] - 2020-12-15

* First official version.
