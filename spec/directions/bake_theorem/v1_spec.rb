# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeTheorem::V1 do

  before do
    stub_locales({
      'theorem': 'Theorem'
    })
  end

  let(:theorem1) do
    note_element(
      <<~HTML
        <div data-type="note" id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170572086324" class="theorem">
          <div data-type="title" id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_14">Two Important Limits</div>
          <p id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170572243382">Let <em data-effect="italics">a</em> be a real number and <em data-effect="italics">c</em> be a constant.</p>
          <ol id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170571659112" type="i">
            <li><div data-type="equation" id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170571611919"><m:math xmlns:m="http://www.w3.org/1998/Math/MathML" display="block"><m:mtext>xyz</m:mtext></m:math></div></li>
            <li><div data-type="equation" id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170571600104"><m:math xmlns:m="http://www.w3.org/1998/Math/MathML" display="block"><m:mtext>abc</m:mtext></m:math></div></li>
          </ol>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(theorem: theorem1, number: '42')

    expect(theorem1).to match_normalized_html(
      <<~HTML
        <div class="theorem" data-type="note" id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170572086324" use-subtitle="true">
          <div class="os-title">
            <span class="os-title-label">Theorem </span>
            <span class="os-number">42</span>
            <span class="os-divider"> </span>
          </div>
          <div class="os-note-body">
            <h4 class="os-subtitle" data-type="title" id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_14">
              <span class="os-subtitle-label">Two Important Limits</span>
            </h4>
            <p id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170572243382">Let <em data-effect="italics">a</em> be a real number and <em data-effect="italics">c</em> be a constant.</p>
            <ol id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170571659112" type="i">
              <li><div data-type="equation" id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170571611919"><m:math xmlns:m="http://www.w3.org/1998/Math/MathML" display="block"><m:mtext>xyz</m:mtext></m:math></div></li>
              <li><div data-type="equation" id="auto_74a09fc9-5f6e-4f6d-a6da-b13c909ad307_fs-id1170571600104"><m:math xmlns:m="http://www.w3.org/1998/Math/MathML" display="block"><m:mtext>abc</m:mtext></m:math></div></li>
            </ol>
          </div>
        </div>
      HTML
    )
  end
end
