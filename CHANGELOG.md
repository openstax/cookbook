# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

* Added `wrap_children` method on elements (minor)
* Refactored `NoteElement` to infer the note title from book-specific locales (minor)
* Added support for a recipe to infer or be given a book-specific locale file (minor)
* Added `NumberedTable` support for titles and always captions (minor)
* Added titles method to `ElementEnumeratorBase` and `ElementBase` (minor)

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
* Added a file for baking composite chapters called (`bake_composite_chapters`) and the respective spec.
(minor change)

## [1.0.0] - 2020-12-15

* First official version.
