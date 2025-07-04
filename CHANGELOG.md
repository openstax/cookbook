# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

* Reapply changes to `BakeIframes`
* Create `v2` `BakeFolio` that uses existing titles/numbers
* Make numbers optional in `v2` `BackFolio`
* Fix `BakeChapterTitle` usage in `algebra-1`

## [v2.26.1] - 2025-05-22

* Revert changes to `BakeIframes`

## [v2.26.0] - 2025-05-20

* Add `suppress_solution_title` to `bake_numbered_exercise`
* Add recipe for `algebra-1`
* Add support for offsets in `ElementBase.os_number`
* Support `unit-closer` pages in TOC
* Fix iframes links for Polish books
* Create `number_parts` method in `ElementBase`
* Create `os_number` method in `ElementBase` for creating `os-number` text
* Add backward-compatible support for unit numbering where possible
* Create `v2` of `BakeEquations` that takes chapters as input instead of book
* Create `v2` of `BakeChapterTitle` that takes chapters as input instead of book
* Remove `ElementBase#rex_link` in favor of generating links elsewhere
* Update `BakeIframes` to mark iframe links as needing rex linking

## [v2.25.1] - 2025-02-25

* Stop baking `answer key` in `additive-manufacturing`

## [v2.25.0] - 2025-01-16

* Bake `glossary` in `additive-manufacturing`
* Do not bake `chapter solutions` in `additive-manufacturing`
* Bake `answer key` in `additive-manufacturing`
* Add section title links to `key terms` in `additive-manufacturing`
* Remove empty `answer key` sections in `data-science`

## [v2.24.0] - 2024-10-24

* Fix `index` to not generate empty module
* Add dots to letter answers in `data-science`
* Add `BakeEmbeddedExerciseQuestion` for baking exercise-like things
* Bake ordered lists as embedded exercise questions in `computer-science`

## [v2.23.0] - 2024-09-09

* Create space between table title and source for lifespan-development
* Change `Multidisplinary` to `Interdisciplinary` in Note/Feature Box Title for `nursing-internal`
* Suppress summary solution for `chapter-review` in `data-science`
* Suppress summary solution for `critical-thinking` in `data-science`
* Suppress summary solution in `BakeInjectedExerciseQuestion`
* Add span wrapper to letter answers in `BakeInjectedExerciseQuestion`

## [v2.22.0] - 2024-08-12
* Revert references to EOS in `lifespan-development`

## [v2.21.0] - 2024-07-26

* Add Codecov secret value in GH settings
* Unnumbered `Learning Objectives` in `computer-science`
* Bake `answer key` in `neuroscience`

## [v2.20.0] - 2024-07-16

* Revert refereces to EOS in `lifespan-development`
* Uncommented elements needed to build `additive-manufacturing`
* Fix typo in selector for `labs-assessments` in `computer-science`

## [v2.19.0] - 2024-06-28

* Bake `exercises` from `note` in `nursing-internal`
* Remove `BakeMathInParagraph` from `computer-science`
* Fix locale typo in `lifespan-development`
* Bake `references` in `lifespan-development`

## [v2.18.0] - 2024-06-03

* Fix `BakeListsWithPara` to bake nested lists

## [v2.17.0] - 2024-05-17

* Add Problem title to unnumbered exercises in `data-science`
* Remove section titles from `group-project` in `data-science`
* Apply `BakeTableColumns` to `data-science`
* Suppress `summary solution` in `data-science`

## [v2.16.0] - 2024-05-03

* Remove `chapter headings (when no solutions) in answer key` in `nursing-internal`
* Bake `injected exercise` with more then one solution
* Move `additive-manufacturing` out of archived recipes and outline test data

## [v2.15.0] - 2024-04-19

* Bake `TableColumns` in `nursing-internal`
* Create `v4` of `introduction` order
* Bake `unfolding-casestudy` note exercises in `nursing-internal`
* Add translations for notes titles and eoc sections to `pl-marketing`
* Create `V2` of `BakeChapterGlossary`
* Change `note titles` in `information systems`
* Change EOC sections in `information-systems`

## [v2.14.0] - 2024-03-22

* Create `BakeExerciseWithTitle` direction for `webview`

## [v2.13.0] - 2024-03-08

* Change title of `data-science` note: Python Feature -> Python Code
* Remove `exercise-context` from `ap-biology` exercises in notes
* Move `references` from EOB to EOC in `data-science`
* Bake `answer-key` in `data-science`
* Change `eoc` sections in `data-science`

## [v2.12.0] - 2024-02-23

* Exclude `hljs-ln` tables from `BakeNumberedTable`
* Add `data-rex-keep` class to promoted webview headers in `BakeOrderHeaders`
* Remove `what-heard` note from `lifespan-development`
* Change `eoc` sections in `lifespan-development`

## [v2.11.0] - 2024-02-09

* Change title for `single-casestudy` note from `nursing-external`
* Create `BakeSortableSection` direction

## [v2.10.0] - 2024-01-30

* Remove preface exercises from `python`
* Add `BakeOrderHeaders` to web recipe
* Bake `eob` in `information-systems`

## [v2.9.0] - 2024-01-12

* Bake `eoc` in `information-systems`
* Bake `notes` in `information-systems`
* Bake `footnotes`, `rex wrappers`, and `target labels` in `information-systems`
* Bake `tables` in `information-systems`
* Bake `figures` in `information-systems`
* Bake `TOC`, `titles` and `appendix` in `information-systems`
* Initialize `information-systems` recipe

## [v2.8.0] - 2023-12-15

* Create `WebPreBakeSetup` and `WebPostBakeRestore` directions
* Add `WebPreBakeSetup` and `WebPostBakeRestore` to web recipe
* Update web recipe to use `book_pages` instead of `book`
* Bake `references` in `data-science`
* Bake `EOC` in `data-science`
* Bake `notes` in `data-science`
* Add `tables` in `neuroscience`
* Added `index` and `appendix` to `neuroscience`
* Bake `lo` in `data-science`
* Add `developmental-perspective` note in `neuroscience`
* Create basic files for `data-science` recipe
* Create `BakeOrderHeaders` direction & specs
* Bake `chapter outline` in `neuroscience`

## [v2.7.0] - 2023-12-01

* Add `in the lab note` in `neuroscience`
* Add Shellcheck to Dockerfile
* Fixup `PageElement`, add specs for `CompositePageElement`
* Bake `answer key` in `lifespan-development`
* Bake `notes` in `lifespan-development`
* Bake `index` in `lifespan-development`
* Bake `eoc` sections in `lifespan-development`
* Bake `tables` in `lifespan-development`
* Bake `figures` in `lifespan-development`
* Create basic files for `lifespan-development` recipe


## [v2.6.0] - 2023-11-17

* Add `boxed-feature` note in `neuroscience`
* Bake EOC sections in  `neuroscience`
* Add `tables` in `neuroscience`
* Add `neurscience across species` note in `neuroscience`
* Bake `learning-objectives` in `neuroscience`
* Add `BakeRexWrappers` to every recipe-- gives an attribute for rex
* Fix problem letter tag in multipart questions
* Adds `meet-author` note in `neuroscience`
* Add `lifestage-context` note to `nursing-internal`
* Add section titles links to `summary` in `nursing-internal`
* Change EOC titles in `nursing-internal`

## [v2.5.0] - 2023-11-03

* Change order of `AnswerKey` sections in `nursing-internal`
* Add `BakeUnnumberedTables` to `python`
* bake-web:
  * Add `ImageElement`, enumerator, and support
  * Update `BakeImages` to use `ImageElement`
  * Update recipes to remove `BakeImages`
  * Add web recipe that calls `BakeImages`
  * Update `bake` script to accept output platform argument
  * Add `generate_test_resources_from_file` script
  * Refactor custom `Matcher`s to be more readable
  * Create test & test data for web pipeline
* Add warning to `BakeTableColumns`
* Add new extension `ruby-lsp`
* Create new version of `references` in form of footnotes
* Add `BakeLinks` to nursing-external recipes

## [v2.4.0] - 2023-10-20

* Add `cases` option to `BakePreface`
* Create recipe for polish marketing
* Add `boxed-feature` note to `nursing-external`
* Create `BakeTableColumns` module
* Add colgroup to `BakeNumberedTables` and `BakeUnnumberedTables`

## [v2.3.0] - 2023-10-06

* Initial Recipe for `neuroscience`
* Add attribute `lang` to index foreign terms

## [v2.2.0] - 2023-09-22

* Fix `V4` of `BakeReferences` and apply it to `nursing-external`
* Add options for multipart questions in `BakeInjectedExercise`
* Revert changes made for `detailed solution` in `python`
* Refactor: Move baking logic from recipe files to centralized executable
  * Change `bake` files to `recipe.rb`
* Refactor: Take out `Strategy` architecture, move logic inline
* Add `V2` of `MoveSolutionsFromAutotitledNote` for `precalculus`
* Fix problem with mathml namespaces in `hs-physics`

## [v2.1.0] - 2023-09-08

* Revert `BakeReferences` version to `V2` in `nursing-external` until fix for webview be ready
* Create `V4` of `BakeReferences` for `nursing-external`
* Bake `injected-exercises` in `anatomy`
* Remove from Dockerfile `git`, `vim`, `openssh-server`, `wget`, `libicu-dev`, and `liveshare`

## [v2.0.0] - 2023-08-24

* Upgrade to Ruby 3
* Upgrade gems
* Update CI config to call recipes & kitchen separately
* Add dot to solutions in `nursing-external`
* Add class `scaled-down` to mechanism figure caption

## [v1.35.0] - 2023-07-27

* Change `nursing-internal` learning objectives from v2 to v1
* Hack organic-chemistry recipe to flatten Chemistry Matters title in the TOC

## [v1.34.0] - 2023-07-13

* Remove section title links from EOC sections in `nursing-internal`
* Bake figures in preface in `all books`
* Reorder EOC sections in `nursing-internal`
* Bake `preview-carbonylchemistry` section in `organic-chemistry`
* Enable `detailed solution` in `python`

## [v1.33.0] - 2023-06-15

* Change `BakeImages` height & width to `data-height` and `data-width`
* Add additional EOC sections to `hs-college-success`
* Support `<img>` markup:
  * Add `Kitchen` infrastructure to allow passing in resources to `Oven#bake`
  * Create `BakeImages` to add image dimensions to `<img>` tags
  * Add resource option & `BakeImages` to all recipes
  * Test that all recipes can receive resources; add match helpers
  * Update main `bake` script for our refactored times
* Bake `figures in preface` in `college-success`


## [v1.32.0] - 2023-06-02

* Suppress `High School Features` in `college-success`
* Remove title from `Appendix` target label in `organic-chemistry`
* Add support for source mapping

## [v1.31.0] - 2023-05-17

* Add `Student Story note` to `hs-college-success`
* Change order of EOC sections in `nursing-external`
* Add `The Real Deal note` to `hs-college-success`
* Change main `bake` script to enable `-r` resource optarg
* Change divider in `UseSectionTitle` method
* Modify `BakeFolio` to add folio paragraphs
* Create recipe  and new unstyled notes for  `hs-college-success`
* Fix `BakeLinkPlaceholders` to replace section link text only in chapter pages

## [v1.30.0] - 2023-05-08

* Improve error message
* Bake more `first elements` in `contemporary-math`

## [v1.29.0] - 2023-04-21

* Add `no-cellborder` and `vertically-tight` tables to `CustomBody`
* Remove numbering from `Learning Objectives` in `bca`
* Change iframe link text

## [v1.28.0] - 2023-04-07

* Add `third_level_selectors` to `BakeFirstElements`
* Create recipe for `nursing-internal`
* Bake `UnitTitle` in `nursing`

## [v1.27.0] - 2023-03-24

* Remove empty space after exercise context
* Bake figures from `preface` in `contemporary-math`
* Revert changes for `exercise-block` class
* Bugfix section link replacement names (using regex)
* Add `BakeIFrame` to Nursing External Recipe
* Create option `problem_with_prefix` for `organic-chemistry`
* Change `Checkpoint` into `Mac Tip` in `bca`
* Change `written-exercises` into `written-questions` in `bca`

## [v1.26.0] - 2023-03-13

* Bake `full-width` tables
* Bake `injected-exercises` in `bca`
* Create Recipe Nursing Series
* Remove numbering from figures without id
* Remove dependence on element id when creating rex links

## [v1.25.0] - 2023-02-24

* Add `top_title` behavior to `BakeUnnumberedTables`
* Add `Chapter Outline` to `college-success`
* Corrected exercise block class name
* Add a warning if a placeholder link doesn't have an id
* Modify `UseSectionTitle` to return when page doesn't exist
* Modified `BakeLinkPlaceholders` to be able to replace certain placeholder text
* Remove Figure title id attribute

## [v1.24.1] - 2023-02-14

* Change `target-label` values in TOC
* Bake caption in unnumbered tables


## [v1.24.0] - 2023-02-10

* Add rex labeling to <li>s generated by `BakeToc`
* Add 'exercise-block' class setting for alphabetical_multipart (optional, added in baked_injected_exercises)
* Remove `numbered_solutions` option from `BakeExample`
* Implement `BakeScreenreaderSpans` to more books
* Add option `move_caption_on_top` to numbered tables
* Create `UseSectionTitle` to move section title to composite page header

## [v1.23.0] - 2023-01-27

* Remove `ElementBase#copied_id` since we don't copy IDs anymore

## [v1.22.0] - 2023-01-13

* Create additional EOC sections in `organic-chemistry`
* Bugfix `BakeUnclassifiedNotes` so title's id isn't copied if empty
* Add `remove_unused_snapshots` script
* Move `aside` elements outside of `spans` in captions (block level element cannot be inside an inline element)
* Bake `dedication-page` note in `organic-chemistry`
* Add `example` to `python`
* Tweak `BakeHighlightedCode` to include `pre`
* Add `BakeHighlightedCode` to add data-lang to code snippets

## [v1.21.0] - 2022-12-16

* Remove blank caption elements from tables
* Update CI to fail right away if kitchen tests fail
* Revert adding `div` wrapper to `BakeEquations`
* Fix injected stepwise element to generate valid HTML

## [v1.20.0] - 2022-10-21

* Bake figures from `Preface` in `Marketing`
* Remove copied duplicate ids

## [v1.19.0] - 2022-10-21

* Change title for `Problems` in `organic-chemistry`
* Unblock page target labels in `pl-u-physics`
* Bake `UnclassifiedNotes` in `marketing`
* Bake equations in `marketing`
* Bake exercises in `python`
* Bake notes in `python`

## [v1.18.0] - 2022-10-07

* Create recipe for `python` book
* Support target labels for `BakeNumberedNotes.v3`
* Fix page numbering in `BakeIndex`
* Change EOC titles in `world-history`
* Modify `BakeNumberedNotes.v1` to bake notes within Appendix
* Add `appendix` to `contemporary-math`

## [v1.17.0] - 2022-09-23

* Modify `BakeEquations` to wrap equations in a `div`
* Use existing ids in `BakeChapterReferences.v2`
* Support dash in iframe link
* Change `world-history` BakeLearningObjectives to v1
* Add support for module title element children (e.g. italics, sup, sub) to be kept while baking

## [v1.16.0] - 2022-09-09

* Add support for figures with class `mechanism-figure` to `BakeFigure` for `organic-chemistry`
* Support trademark symbol in iframe link
* Change eoc hierarchy in `world-history`
* Add `shorten` recipe for contemporary-math
* Bake `key-terms` in `organic-chemistry`
* Add class to `target-label`
* Add `data-toc-target-page-type` attribute to TOC lis

## [v1.15.0] - 2022-08-25

* Remove section subtitle from `Summary of Reaction` in `organic-chemistry`
* Replace `Something Extra` note with `Chemistry Matters` in `organic-chemistry`
* Remove section subtitle from `Summary` in `organic-chemistry`
* Fix adding additional white spaces inside figure caption children in `BakeFigure`
* Fix additional whitespeces after solution number in `BakeInjectedExerciseQuestion`
* Change `BakeIndex` so that `terms` only change their `ids` if an `id` is not already present
* Remove title from section exercises in `organic-chemistry`
* Fix eoc title in `organic-chemistry`
* Change organic chemistry locale of `Chapter Outline` to `Chapter Contents`
* Remove working problems from class baked notes in `organic-chemistry`
* Set the `dummy` recipe to always be English so I18n does not complain

## [v1.14.0] - 2022-08-11

* Modify `BakeListsWithPara` to change `only-child` paragraphs
* Modify `BakeIndex` to display all children of term not just text
* Enable `target labels with cases` for Introduction(`BakeChapterIntroductions.v2`), Non-Intro Modules (`BakeNonIntroductionPages`), Appendixes (`BakeAppendix`) for `pl-economics`, adjust `BakeChapterTitle`, `BakeToC`, and `AnswerKeyInnerContainer` to use `chapter title` cases for pl books which utilizes them
* Add `learning-objectives` note to `pl-economics`
* Change text in folio for Polish books
* Add more selectors to `BakeFirstElements`
* Change the way of baking title in `BakeChapterSectionExercises`
## [v1.13.0] - 2022-07-28

* Add answer key to `organic-chemistry`
* Add `diseases` note to `anatomy`
* Change `Example` title to `Worked Example` for `organic-chemistry`
* Add option `add_dot` to `BakeInjectedExerciseQuestion` for question answers
* Change figure title to `Ilustracja` in Polish books
* Bake `narrow-table`
* Add EOC sections to `organic-chemistry`
* Add option for alphabetical multipart questions in `Bake_Injected_Exercises`
* Add `ElementBase#add_platform_media`
* Update `BakeIframes` and `BakeScreenreaderSpans` to use new media switch markup
* Translations added for Organic Chemistry eoc sections

## [v1.12.0] - 2022-07-18

* Specify header to remove form EOC in `Marketing`
* Change EOC title in `Marketing`
* Add baking for `.interactive` note on ap-physics
* Add notes to `organic-chemistry`
* Fix `college-physics-2e` link text (call `BakeLinkPlaceholders` in both recipes)
* Add locales to `organic-chemistry`
* Create basic `organic-chemistry` recipe
* Add `BakeUnitPageTitle` in `marketing` recipe

## [v1.11.0] - 2022-06-30

* Add `.careers-marketing` to marketing recipe
* Archive `additive-manufacturing`

## [v1.10.0] - 2022-06-21

* Add support for creating index name term content from name attribute instead of reference if they don't have it for `pl-economics`.
* Add `options` parameter to pass options to `BakeNumberedNotes`
* Add `options` parameter to pass options to `BakeAutotitledNotes`
* Add `options` parameter to pass options to `BakeNumberedExercise`
* Add `options` parameter to pass options to `BakeExample`

## [v1.9.0] - 2022-06-03

* Add optional baking exercise problem title to `BakeExample` direction for `statistics`
* Add support for baking learning objectives in appendices (`BakeLearningObjectives`) for `marketing`

## [v1.8.0] - 2022-05-23

* Fix bad encoding in AP physics locales
* Add `BakeFirstElements` to examples in `dev-math`
* Change `references title` from `Endnotes` to `References` for `marketing`
* Create `BakeAppendixFeatureTitles` direction to allow appendices feature sections titles be dynamic
* Add `BakeFirstElements` direction to `college-physics`, `college-physics-2e` recipes
* Add support for baking injected exercises/solutions in appendices

## [v1.7.0] - 2022-05-06

* Add `BakeAppoendix` direction to `pl-economics` recipe
* Add `String#kebab_case`
* Fix `ElementBase#rex_link` so that all title strings get kebabified
* Fix injected exercises to bake mcqs with detailed solutions

## [v1.6.0] - 2022-04-22

* Remove choice level feedback from answers in injected questions
* Change string for section exercises in `Precalculo`
* Switch kitchen tests over to snapshots
* Patch Precalculus recipe for precalculo

## [v1.5.1] - 2022-04-18

* Change `qa` note title label translation for precalculo
* Fix bug introduced in #40 by adding ids to introduction pages
* Remove iframe baking from `BakeAutotitledNotes`
* Define rex_link on `ElementBase`
* Link to rex from iframe in `BakeIframes`

## [v1.5.0] - 2022-04-08

* Add `BakeFootnotes` to ap physics
* Fix adding unnecessary dividers in `BakeFigure` when no title, caption (patch)
* Add `BakeCompositeChapters` to `college-physics-2e` (minor)

## [v1.4.0] - 2022-03-24

* Update recipes with `BakeUnnumberedFigure`. Allow baking all unnumbered figures (even without caption and title) within `BakeUnnumberedFigure` (patch)
* Remove `bake_root`
* Added a skip for chapters with no solutions in `your-turn` notes inside `MoveSolutionsFromNumberedNote` (minor)

## [v1.3.1] - 2022-03-21

* Replace normalization with validation
* Remove references to easybake
* Add `BakeListsWithPara` `pl-economics` recipe (minor)
* Remove extra space between os-number and divider in solutions (patch)
* Created a `v2`in `MoveSolutionsFromNumberedNote` for multiple responses in `your-turn` notes
exercises with different numbering (minor)
* Do not rely on autogenerated page title id for creating links to pages

## [v1.3.0] - 2022-3-11

* Remove `testing-anchor` recipe (minor)
* Add `script/update_recipes_spec_data`
* Add target labels to Introduction and Non Introduction modules, Appendixes (patch).
* Remove extra whitespace between exercise numbers and divider(patch)
* Do `AP_PHYSICS_RECIPE` re usable for 2e (minor).
* Do `COLLEGE_PHYSICS_RECIPE` re usable for 2e (minor).
* Add specific baking for `authentic-assessment` sections in `college-physics-2e` (minor).
* Restore `Answer Key` for `college-physics-2e` (minor).

## [v1.2.0] - 2022-2-25

* Add `BakeCustomSection` behavior for specific document subtitles (minor)
* Remove eoc subheading in finance (patch)
* Change Spanish titles to title case (patch)
* Add `link-to-learning` note to `marketing` (patch)
* Change way of baking exercises in `marketing` after content changes (patch)
* Bake `excel-spreadsheet` note in `finance` (patch)
* Create recipe for `marketing` (major)
* Update all recipes to contain `BakeLinkPlaceholder` and `BakeFolio` (patch)
* Creeate `BakeLinks` and add to all recipes, for Rex (major)
* Update locales files, specs for pl microeconomics, pl-u-physics, pl-psychology (patch)
* Add support for tables wioth classes `data-table`, `timeline-table` to `BakeNumberedTable.v1`
* Change iframes behavior to include the (url...) in link (major)
* Create `BakeCustomTitledNotes` for notes with classes that have custom title (minor)
* Modify `BakeChapterIntroductions` to bake intro with unit opener note (minor)
* Add more updates to `pl-economics` recipe bake file. Fix `shorten` script paths, change kitchen.ci to cookbook in docker run `rubocop` file (patch)
* Modify how `recipes_helper` requires `imports_for_recipes`
* Remove hacky numbering part from `contemporary-math's strategy` (minor)
* Remove extra link being added in content text inside iframes (`BakeIframes.v1`) (major)

## [19.0.0] - 2022-1-28

* Add features to `BakeScreenreaderSpans` & use translations instead of plaintext (minor)
* Create `AnswerKeyCleaner` to remove empty chapter containers (minor)
* Change markup to `span` with `sup` for reference link separator `BakeReferences.v1` plus remove whitespaces and new lines (patch)
* Changes to `BakeScreenreaderSpans` behavior (major)
* Changes to `BakeToc` to improve error messaging by including `page.id` (minor)

## [18.0.0] - 2022-01-14

* Fix links in `BakeHanbook` outline to point sections (patch)
* Add unit title prefix with number to `BakeUnitPageTitle` (patch)
* Add `scope="col"` attribute to `BakeTableBody` and `BakeUnnumberedTables` (major)

## [17.1.0] - 2021-12-17

* Add append_to support to `BakeChapterSummary` (minor)
* Add support for italicized terms in index (minor)
* Fix problem with namespaces in `BakeLinkPlaceholders` and `BakeIndex` (minor)
* Create `V3` for `BakeChapterReferences`  which sorts references alphabetically (minor)

## [17.0.0] - 2021-12-3

* Create method in `Integer` class that generate roman numbers up to 100 (minor)
* Add more roman numbers to `Integer` class (patch)
* Create `V2` for `BakeChapterReferences` (minor)
* Create `BakeExercisePrefixes` direction adding prefixes for exercises in selected sections (minor)
* Add support for 'text-heavy-top-titled' tables in `BakeTableBody` (minor)
* Remove `Nokigiri#previous` patch, `ElementBase#previous` now uses `#previous_element` (minor)
* Modifies `BakeAnnotationClasses` for annotations wrapper to be a `span` intead of a `div` (major)

## [16.0.0] - 2021-11-19

* Add reference link separator to `BakeReferences.v1` (patch)
* Modify `BakeFootnotes` to be more general (minor)
* Add `#preceded_by_text` method to element_base and the nokigiri patch (minor)
* Remove `Nokigiri#previous` patch, `ElementBase#previous` now uses `#previous_element` (minor)
* Broaden caption selection for `BakeNumberedTable#v2` (patch)
* Add details of question count to injected exercises in `BakeInjectedExercise` (major)
* Add target labels to chapter content module pages option in `BakeNonIntroductionPages`, create a separate directory `BakeLOLinkLabels` to add `.label-text`, `.label-counter` spans wrappers for links with `.lo-reference` class (minor)
* Add `BakeScreenreaderSpans` direction (minor)
* Fix `BakeIndex` to group terms by character in polish books and transliterate it for others (minor)
* Add optional bake `exercies-context` figure_reference if there is one present in singular part exercises to `BakeInjectedExercise`,`BakeInjectedQuestion` to move it down from exercise to question problem container. (major)
* Create v3 for autotitled exercises with os-hasSolution class

## [15.0.0] - 2021-11-05

* Add unstyled tables to `BakeTableBody` (minor)
* Add to `BakeNumberedExercises` rules for baking exercises in appendecies (minor)
* Add `BakeUnnumberedExercise` direction (minor)
* Change whitespace for `BakeIndex` and `BakeExample` (major)
* Add `BakeAllNumberedExerciseTypes` direction for easier baking of compound sections (minor)
* Add `solution_stays_put` option for `BakeNumberedExercise` (minor)
* Add `BakeAllChapterSolutionsTypes` direction to move injected solutions and regular ones to EOC (minor)
* Refactor: moves all `Answer key strategies` that are book-specific to the
recipes side and keeps the `Default Strategy`in kitchen (major)
* Adds missing spanish translations (minor)

## [14.0.0] - 2021-10-22

* Fix `BakeAutotitledExercise` V2 to stop breaking for exercises without solutions (patch)
* Add `BakeAutotitledExercise` V2 (minor)
* Fix `BakeChapterGlossary::V1` to stop adding an empty wrapper if there is no content (patch)
* Create `BakeNoteExercise` and `BakeNoteInjectedQuestion` and support exercises in `BakeUnclassifiedNotes` (minor)
* Add baking section with class `column header` to `BakeAppendix` (patch)
* Expand `BakeAnnotationClasses` to book from chapter to bake also paragraphs from Preface (major)
* Create separate direction `BakeUnnumberedFigure`, clean `BakeFigure` to not match unnumbered figures , rename and update `figure_to_bake?` method to `figure_to_number?` to support only numbered figures except subfigures (major)

## [13.0.0] - 2021-10-6

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
