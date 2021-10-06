# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

* Add `BakeLearningObjectives` v3 (minor)
* Fix `BakeIframes` to skip already-baked iframes (patch)
* Add `SectionElement` and `SectionElementEnumerator` classes (minor)
* Refactor `EocCompositePageContainer` to be used by `EOB` sections as well (major)
* Refactor `bake_references` `v1, v2 and v3` to use `CompositePageContainer` (major)

## [12.2.0] - 2021-10-1

* Add `context_lead_text` to translations (minor)
* Make `ElementBase#search_with` callable from an `ElementEnumerator` (minor)
* Support top-titled tables in `BakeUnnumberedTables` (minor)
* Stop `NoteElement#title` from breaking for empty notes (patch)
* Add text heavy tables to `BakeTableBody` (minor)
* Modify `BakeAutotitledNotes` to bake unnumbered exercises with solution (minor)
* Create `AddInjectedExerciseId` to separate creating ids from `BakeInjectedExerciseQuestion` (minor)
* Rework `AddInjectedExerciseId` to use loop inside module (minor)

## [12.1.0] - 2021-09-24

* Fix `BakeExample#titles_to_rename` to exclude exercise titles (patch)
* Modify `BakeFigure` to bake unnumbered figures with caption (minor)
* Fix `NoteElement#title` to be more specific about finding the title (patch)
* Adds `data-type="slug"` to `metadata_lement` `children_to_keep` method, updates spec helper `metadata_element` and related spec files(minor)

## [12.0.0] - 2021-09-21

* Fixes `BakeStepwise` to skip nested lists (patch)
* Adds an optional selector to `RemoveSectionTitles` (minor)
* Patches `BakeFreeResponse` to only delete the first h3, not all h3s (patch)
* Lets `BakeExample` not count titles in lists as commentary titles (minor)
* Renames `BakePageAbstracts` to `BakeLearningObjectives` and adds optional parameter for titles in `v2` (major)
* Gets rid of extraneous titles in `BakeAutoTitledNotes` when subtitles are off (minor)
* Adds `BakeAutotitledExercise` direction and the option to `bake_unclassified_exercises` within `BakeAutotitledNotes`
* Adds optional numbering for `BakeReferences.v1` (minor)
* Patches`BakeNumberedNotes.v3` to suppress solutions outside examples when suppress_solutions is true (minor)

## [11.2.0] - 2021-09-10

* Adds `BakeAccessibilityFixes` direction for (minor)
* Remove deprecation warning from `BakeChapterIntroductions.v1` and adapted to be used like `.v2` (minor)
* Small class fix for `BakeFootnotes.v1` (patch)
* Fix `BakeNumberedNotes` to find related example better (minor)
* Small fix for parameter in `bake_note` definition (minor)
* Small fixes to return when no elements are found and not add an empty wrapper in `BakeChapterReferences` and
`BakeFreeResponse` (minor)
* Adding class `os-timeline-table-container` to numbered tables when required (minor)
* Fix `BakeExample` to catch the multiple solutions to one exercise (patch)

## [11.1.0] - 2021-08-30

* Update injected questions to synthesize ids during baking (minor)
* Fix `BakeListsWithPara` to copy all children from para not just text (minor)
* Implement labels with cases to `BakeAutotitledNotes` and `BakeNumberedNotes` (minor)
* Add ids to injected questions (minor)
* Create `BakeIframes` outer directory to allow bake iframes also from outside notes, remove `BakeNoteIFrames` module from notes directory (minor)
* Update the contemporary math `Strategy` to target injected solution sections (minor)
* Update `BakeNumberedNotes` to handle injected questions in notes (minor)
* Create `InjectedQuestionElement` and `InjectedQuestionElementEnumerator` classes (minor)
* Create `BakeInjectedExercise` and `BakeInjectedExerciseQuestion` directions (minor)
* Update `MoveSolutionsFromExerciseSection` and `MoveSolutionsFromNumberedNote` to move injected solutions (minor)
* Add `SolutionElementEnumerator` to support the above (minor)
* Remove multipart exercise baking from `BakeNumberedExercise`; this is now done in `InjectedExercise` directions (patch)
* Modify target labels to use grammatical cases (minor)
* Modify `BakeIndex` to bake multiple types of indexes (minor)
* Create `v2` in `BakeChapterIntroductions` that should replace `v1` (minor)
* Added a DEPRECATION warning in `v1` for `BakeChapterIntroductions` (minor)
* Added a bit more description to deprecation warning for `BakeChapterIntroductions.v1`  (minor)

## [11.0.0] - 2021-08-6

* Add `ChangeSubsectionTitleTag` direction for modifying eoc sections (minor)
* Add `MoveSolutionsFromNumberedNote`, `MoveSolutionsFromExerciseSection`, and `SolutionAreaSnippet` for answer key baking (minor)
* Refactor the following `Strategies`: contemporary math, precalculus, uphysics (minor)
* Fix `BakeUnitPageTite` to utilize only pages which are direct children of the unit (patch)
* Patch `BakeFirstElements` to include first figure elements (patch)
* Refactor `MoveCustomSectionToEocContainer` to remove `include_intro_page` (major)
* Update `BakeFirstElement` to optionally add the `has-first-inline-element` class (patch)
* Patch `BakeExample` crashing if an example has commentary but no title (patch)
* Refactor `EocSectionTitleLinkSnippet` to only have v1 with optional params (major)
* Adds `PageElement#count_in_chapter_without_intro_page` (minor)
* Adds `ChapterElement#has_introduction?` (minor)
* Adds `BakeFolio` to set spanish translation variables in the html tag for folio-pdf purposes (minor)
* Create `BakeCustomSections` direction for English Composition (minor)
* Create `BakeAnnotationClasses` v1 for English Composition (minor)

## [10.0.0] - 2021-07-30

* Add support for baking multipart questions to `BakeNumberedExercise` (minor)
* Add `has_para` option to `BakeChapterGlossary` for books from Adaptarr (minor)
* Create `BakeListsWithPara` to remove paragraphs from lists in books created by Adaptarr (minor)
* Create `Strategy::ContemporaryMath` (minor)
* Stop `BakeTableBody` from blowing up when table doesn't have an ID (patch)
* Refactor `MoveExercisesToEOC::V2` & `BakeChapterKeyConcepts` to use `MoveCustomSectionToEocContainer` (minor)
* Add wrapper support for `MoveCustomSectionToEocContainer` (minor)
* Create `BakeHandbook` direction (minor)
* Add `ExampleElement#titles_to_rename` & refactor `BakeExample` (patch)
* Create `BakeUnitPageTitle` (minor)
* Fix `BakeExample` to skip baked exercises (patch)
* Add `FigureElement#figure_to_bake?` (minor)
* Remove `itemprop` attribute from `BakeChapterSummary` and `BakeFurtherResearch` (major)
* Fix `NoteElement#title` to exclude nested element titles (patch)
* Remove `BakeTheorem` (minor)
* Allow `BakeChapterSolutions` to bake solutions from multiple sections (minor)
* Add `.os-problem-container` to `BakeFirstElement` selectors (minor)
* Tweak `BakeExample` to not touch unbaked titles in captions (minor/patch)
* Tweak `BakeNumberedTables.v1` to cut extra white space (minor)

## [9.2.0] - 2021-07-19

* Update `BakeFirstElements` to also add the `.has-first-inline-list` class (minor)

## [9.1.0] - 2021-07-16

* Add `BakeNoteIFrames` direction (minor)
* Selector optimization in precalculus `Strategy` & elsewhere (patch)
* Tweaks inline list seperators to only target labeled items (major?)
* Add definition of handbook page selector needed for BakeToc, create a link class for this page (minor)

## [9.0.0] - 2021-07-12

* Refactor `BakeChapterKeyConcepts`, `BakeChapterReferences`, `BakeChapterSolutions`, and `MoveExercisesToEoc` versions 1-3 to use new general eoc directions (major)
* Fixed `BakeExample.v1` to also search inside `.body` for titles (minor)
* Add documentation to `MoveCustomSectionToEocContainer` & `EocCompositePageContainer` (minor)
* Add a `MoveCustomSectionToEocContainer` to allow for custom sections (minor)
* Add a `EocCompositePageContainer` direction to handle creation of eoc page wrapper (minor)
* Refactor `BakeChapterKeyEquations`, `BakeChapterGlossary`, `BakeChapterSummary`, `BakeFurtherResearch` (major)
* Fix metadata title in composite pages (major)

## [8.0.1] - 2021-06-29

* Added tags to classnames to optimize searches in `calculus strategy` for `move_solutions_to_answer_key` (minor)

## [8.0.0] - 2021-06-29

* Sort terms in `BakeChapterGlossary` in language specific way (major)
* Spanish translation change (minor)
* Fixed the implementation of `Element#wrap_children` to reuse existing document elements (major).

## [7.0.0] - 2021-06-21

* Changed selector expected by `default strategy` in `move_solutions_to_answer_key` to optimize search (major)
* Fix Rubocop GitHub Action's regular expression used to select files to lint (patch)
* Add optional numbering to multiple solutions inside examples (minor)
* Added monkey patch for array to be able to add a prefix: `%w[multiple-choice true-false].prefix('section.')` (minor)
* Add more specific book part selector (`os-eob`) for References in `is_citation_reference?`, `is_section_reference?` methods in `Element Base` to fix toc selector for References which are moved to EoC (major)

## [6.1.0] - 2021-06-21

* Create a `BakeReferences` V2 for unnumbered section references (minor)
* Don't check for CHANGELOG when merge a PR to main (patch)
* Added `BakeInlineLists` (minor)

## [6.0.0] - 2021-06-15

* Allow `BakeChapterSummary` to skip pages where there is no summary (minor)
* Change `PageElement#summary` to return nil instead of raise an error if no matches (major?)
* Fix bug in `BakeNumberedNotes:::V3` when there are multiple os-numbers (minor)
* Add Rubocop and a working CHANGELOG check to GitHub actions (patch)
* Allow `BakeFootnotes` to number footnotes with Roman numerals (minor)
* Create V2 for `BakeNumberedTables` (minor)
* Remove extraneous title in `BakeChapterSectionExercises` (minor)
* Create V2 for `BookAnswerKeyContainer` and `MoveSolutionsToEOC` with singular option for wrapper class (minor)
* Delete `abstract` and `description` elements from preface in `BakePreface` (minor)
* Stop deleting the first `<strong>` tag in `BakeNumberedNotes` (major)
* Allow `BakeFigure` to bake unnumbered splash figures (minor)
* Extend `ChapterReviewContainer` to accept other classes (major?)
* Add a `Strategy` for Precalculus (minor)
* Create a `BakeNumberedNotes` V2 (minor)
* Added a version of `BakeChapterIntroductions` without a chapter outline (minor)
* Add `BakeChapterSolutions` which bakes the free response solutions at the eoc (minor)
* Changed locale `eoc_answer_key_title` to `answer_key_title` as it was only used in eob (major)
* Added spec for translations (minor)
* Remove summary attribute from numbered tables, add option to pass title element to `BakePreface` (minor)
* Renamed `American Government` strategy to `Default` inside `move_solutions_to_answer_key` for other books to use it with a sent in classname (major)
* Adds `#previous` method to note_elements to find the immediately previous element (minor)
* Adds `BakeNumberedNotes` V3 (minor)
* Added line that puts the classname `has-footnote` in the footnote ref's parent element (major)
* Added a condition into `BakeChapterSummary` so it doesn't bake the title if it already includes the respective number in it
* Create v3 of `MoveExercisesToEOC` which differs from v1 by the presence of a section title
and from v2 the lack of additional `os-section-area` and `os-#{@klass} wrapper` (minor)
* Add a condition in `BakeNumberedExercise` to make it possible to suppress even solutions in the Answer Key (minor)
* Fix `BakeFurtherResearch` baking with main bake script error by breaking the loop if further research sections are not present (minor)
* Rework v1 of `BakeChapterReferences` to bake references also from introduction pages (major)
* Fix for `BakeIndex` for words that start with a number to be grouped as symbols and for first letters with accent marks to be grouped with regular letters in alphabetic order (major)

## [5.0.0] - 2021-06-02

* Reditributed duplicated id logic across `#record_id_copied`, `#record_id_cut`, `#record_id_pasted`, added a couple more tests for `#copy`, `#cut`, and `#paste`, created a new class `IdTracker` and moved `#record_id_copied`, `#record_id_cut`, `#record_id_pasted`, and `modified_id_to_paste` into the new class (major)
* Moved selectors from recipe to kitchen on `BakeFirstElements` Direction (minor)
* Auto-detect language based on document; force output encoding to UTF-8 (major)
* Switched to using a library to sort strings in a language-specific way (patch)
* Remove summary attribute from `BakeNumberedTable` (major)

## [4.1.1] - 2021-05-24

* Adds low level Nokogiri caching, disabled by default (patch)
* Cache Selector objects since they don't change (patch)
* Use more specific selectors when to reduce bake time (patch)

## [4.1.0] - 2021-05-18

* Fixed performance problem with element class detection (patch)
* Added `BakeChapterReferences` Directions (minor)

## [4.0.0] - 2021-05-18

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

## [3.2.0] - 2021-04-20

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
