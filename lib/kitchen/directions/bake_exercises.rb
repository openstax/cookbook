module Kitchen
  module Directions
    module BakeExercises

      def self.v1(book:)
        # TODO put the _copy_1 suffix on ID logic into `copy` as an option?
        # have document keep a list of IDs and how many copies have been made
        metadata_elements = book.metadata.search(%w(.authors .publishers .print-style
                                                    .permissions [data-type='subject'])).copy
        # debugger
        solutions_clipboards = []

        book.chapters.each do |chapter|
          exercise_clipboard = Clipboard.new
          solution_clipboard = Clipboard.new
          solutions_clipboards.push(solution_clipboard)

          chapter.pages.each do |page|
            next if page.is_introduction?

            exercise_section = page.exercises
            exercise_section.first("h3").trash # get rid of old title
            exercise_section_title = page.title.clone
            exercise_section_title.name = "h3"
            exercise_section.prepend(child:
              <<~HTML
                <a href="##{page.title.id}">
                  #{exercise_section_title}
                </a>
              HTML
            )

            exercise_section.search("[data-type='exercise']").each do |exercise|
              bake_exercise_in_place(exercise: exercise)
              exercise.first("[data-type='solution']")&.cut(to: solution_clipboard)
            end

            exercise_section.cut(to: exercise_clipboard)
          end

          chapter.append(child:
            <<~HTML
              <div class="os-eoc os-exercises-container" data-type="composite-page" data-uuid-key=".exercises">
                <h2 data-type="document-title">
                  <span class="os-text">#{I18n.t(:exercises)}</span>
                </h2>
                <div data-type="metadata" style="display: none;">
                  <h1 data-type="document-title" itemprop="name">#{I18n.t(:exercises)}</h1>
                  #{metadata_elements.paste}
                </div>
                #{exercise_clipboard.paste}
              </div>
            HTML
          )
        end

        # # TODO v1 should be a different file

        # # TODO every time we paste something that was copied, that is when we need to tack on the ID copy_X

        solutions = solutions_clipboards.map.with_index do |solution_clipboard, index|
          <<~HTML
            <div class="os-eob os-solution-container " data-type="composite-page" data-uuid-key=".solution#{index+1}">
              <h2 data-type="document-title">
                <span class="os-text">#{index+1}</span>
              </h2>
              <div data-type="metadata" style="display: none;">
                <h1 data-type="document-title" itemprop="name">#{index+1}</h1>
                #{metadata_elements.paste}
              </div>
              #{solution_clipboard.paste}
            </div>
          HTML
        end

        book.append(child:
          <<~HTML
          <div class="os-eob os-solution-container " data-type="composite-chapter" data-uuid-key=".solution">
            <h1 data-type="document-title" id="composite-chapter-1">
              <span class="os-text">#{I18n.t(:eoc_answer_key_title)}</span>
            </h1>
            <div data-type="metadata" style="display: none;">
              <h1 data-type="document-title" itemprop="name">#{I18n.t(:eoc_answer_key_title)}</h1>
              #{metadata_elements.paste}
            </div>
            #{solutions.join("\n")}
          </div>
          HTML
        )
      end

      def self.bake_exercise_in_place(exercise:)
        # Bake an exercise in place going from:
        #
        # <div data-type="exercise" id="exerciseId">
        #   <div data-type="problem" id="problemId">
        #     Problem Content
        #   </div>
        #   <div data-type="solution" id="solutionId">
        #     Solution Content
        #   </div>
        # </div>
        #
        # to
        #
        # <div data-type="exercise" id="exerciseId" class="os-hasSolution">
        #   <div data-type="problem" id="problemId">
        #     <a class="os-number" href="#exerciseId-solution">1</a>
        #     <span class="os-divider">. </span>
        #     <div class="os-problem-container ">
        #       Problem Content
        #     </div>
        #   </div>
        #   <div data-type="solution" id="exerciseId-solution">
        #     <a class="os-number" href="#exerciseId">1</a>
        #     <span class="os-divider">. </span>
        #     <div class="os-solution-container ">
        #       Solution Content
        #     </div>
        #   </div>
        # </div>
        #
        # If there is no solution, don't add the 'os-hasSolution' class and don't
        # link the number.

        problem = exercise.first("[data-type='problem']")
        solution = exercise.first("[data-type='solution']")

        problem_number = "<span class='os-number'>#{exercise.count_in(:chapter)}</span>"

        if solution.present?
          solution.id = "#{exercise.id}-solution"

          exercise.add_class("os-hasSolution")
          problem_number = "<a href='##{solution.id}' class='os-number' >#{exercise.count_in(:chapter)}</a>"

          solution.replace_children(with:
            <<~HTML
              <a class="os-number" href="##{exercise.id}">#{exercise.count_in(:chapter)}</a>
              <span class="os-divider">. </span>
              <div class="os-solution-container ">#{solution.children}</div>
            HTML
          )
        end

        problem.replace_children(with:
          <<~HTML
            #{problem_number}
            <span class="os-divider">. </span>
            <div class="os-problem-container ">#{problem.children}</div>
          HTML
        )
      end

    end
  end
end
