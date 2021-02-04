# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MatchHelpers do
  let(:e1) do
    new_element(
      <<~HTML
        <div id="divId">
        <p id="id1">One</p>
        </div>
      HTML
    )
  end

  let(:e2) do
    new_element(
      <<~HTML
        <div id="divId"><p id="id1">One</p>
          <p id="id2">Two</p>
          <span id="id3">Three</span>
          <p id="id4">Four</p>
        </div>
      HTML
    )
  end

  let(:e3) do
    new_element(
      <<~HTML
        <div id="divId">
          Hello<p id="id1">One</p>
        </div>
      HTML
    )
  end

  let(:e4) do
    new_element(
      <<~HTML
        <div id="divId">

          <p id="id1">One</p>
        </div>
      HTML
    )
  end

  describe 'match_html_strict' do
    it 'works when html is not strictly the same (identation)' do
      expect(e1).not_to match_html_strict(e2)
    end

    it 'works when html is strictly the same (removes newlines)' do
      expect(e1).to match_html_strict(e4)
    end
  end

  describe 'match_normalized_html' do
    it 'works with no strict spaces or newlines' do
      expect(e4).to match_normalized_html(
        <<~HTML
          <div id="divId"><p id="id1">One</p></div>
        HTML
      )
    end
  end

  describe 'match_normalized_html_with_stripping' do
    it 'works with stripping' do
      expect(e3).to match_normalized_html_with_stripping(
        <<~HTML
          <div id="divId">
            Hello<p id="id1">One</p>
          </div>
        HTML
      )
    end

    it 'fails with extra space' do
      expect(e3).not_to match_normalized_html_with_stripping(
        <<~HTML
          <div id="divId">
            Hello <p id="id1">One</p>
          </div>
        HTML
      )
    end
  end

  describe 'match_html_nodes' do
    let(:note_element) do
      new_element(
        <<~HTML
          <div data-type="note" id="noteId" class="chemistry link-to-learning">
            <p id="pId">Blah</p>
          </div>
        HTML
      )
    end

    it 'works' do
      expect(note_element).not_to match_html_nodes(
        <<~HTML
          <div data-type="note" id="noteId" class="chemistry link-to-learning">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Link to Learning</span>
            </h3>
          </div>
        HTML
      )
    end

    it 'colorizes difference' do
      failed_message = match_html_nodes(
        <<~HTML
          <div data-type="note" id="noteId" class="chemistry link-to-learning">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Link to Learning</span>
            </h3>
          </div>
        HTML
      )
      expect(failed_message).to match(colorize('expected that actual:', :yellow))
    end

    it 'outputs difference' do
      failed_msg = match_html_nodes(
        note_element,
        <<~HTML
          <div data-type="note" id="noteId" class="chemistry link-to-learning">
            <h3 class="os-title" data-type="title">
              <span class="os-title-label">Link to Learning</span>
            </h3>
          </div>
        HTML
      ).failure_message

      expect(failed_msg).to match('Diff:')
    end
  end
end
