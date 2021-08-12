# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Kitchen::Directions::BakeAnnotationClasses::V1 do

  let(:chapter) do
    chapter_element(
      <<~HTML
        <div class="chapter-content-module" data-type="page">
          <p class="annotation culture-icon linguistic-icon" id="auto_c94c7ae0-0c9f-4249-817b-560d3c686ed5_fs-idm248159488">You, like all people, express your <span data-type="term" group-by="i" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term5">identity</span> (idea about who you are) through language. The language you use also signals the ways you are rooted in specific <span data-type="term" group-by="c" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term6">cultures</span> (groups of people who share common beliefs and lived experiences). Because the ways in which people speak and write are closely intertwined with their self-images and community affiliations, you can think, communicate, and interact most freely with others by using your personal <span data-type="term" group-by="i" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term7">idiolect</span> (your individual way of speaking and writing), which is based in <span data-type="term" group-by="c" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term8">cultural</span> language use. This section examines a few myths about language use and explores some productive ways to think about language and communication.
          </p>
          <p class="annotation culture-icon linguistic-icon" id="auto_c94c7ae0-0c9f-4249-817b-560d3c686ed5_eip-958">
          Even though individuals speak and write effectively by using different varieties of English, many people nevertheless believe that one standard, &#x201C;proper&#x201D; English variety exists and that this &#x201C;correct&#x201D; way of speaking and writing should be used universally in all settings. This viewpoint considers varieties of English outside the imagined norm to be &#x201C;wrong,&#x201D; &#x201C;bad,&#x201D; or &#x201C;substandard.&#x201D; For example, speakers of some Southern English varieties are often judged as &#x201C;poor&#x201D; or &#x201C;unintelligent.&#x201D; If you speak and write using one of those undervalued English varieties, others may have judged you for your language use or told you that your writing is &#x201C;wrong.&#x201D; Even without such judgement, you may have felt apprehensive when sharing your writing with others; you still may fear a harsh assessment, or you may feel vulnerable when others see your compositions.
          </p>
          <p class="annotation auditory-icon kinesthetic-icon" id="auto_c94c7ae0-0c9f-4249-817b-560d3c686ed5_eip-677">The truth is that people speak and write in different ways for different <span data-type="term" group-by="r" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term9">rhetorical situations</span> (instances of communication). People in different communities and professions employ distinct kinds of English. You already use different varieties of English in different parts of your life; as you progress through college and into your career, you will learn the language expectations for the rhetorical situations you will encounter in those spaces. In learning these expectations, you will gain new identities. For example, you may become someone who knows how to write an exemplary lab report, you could develop an identity as an emerging researcher in any number of fields, or you simply may become someone who is comfortable letting other people see your writing. These new linguistic identities do not need to replace your language use in other areas of your life. For instance, you should not feel the need to use a different form of grammar or punctuation in your social media posts. You should feel comfortable using your familiar English varieties in familiar rhetorical situations and, if needed, use new varieties of English you may learn in the new rhetorical situations you encounter. Additionally, you can, and should, seek out opportunities to use your familiar, nonacademic English varieties in academic and professional settings when you feel it is appropriate and aligns with the expectations of your instructor or employer.
          </p>
          <p class="annotation dreaming-icon speech-icon visual-icon" id="auto_c94c7ae0-0c9f-4249-817b-560d3c686ed5_eip-61">Because people write in many different settings for many reasons, no particular English variety is appropriate for all writing tasks. As you become more familiar with the ways English is used in different settings and communities, you can choose which variety to use. You also may choose whether to meet or to disrupt the expectations of the people you are communicating with. In making these choices, you will rely on your existing literacies as well as newly learned ones.
          </p>
        </div>
        <div class="chapter-content-module" data-type="page">
          <p class="annotation culture-icon linguistic-icon" id="auto_b8ea2055-f5a8-444d-a114-b4afbd2dfee5_fs-idm370565488">In her 2018 best seller, <em data-effect="italics">Educated: A Memoir</em>, Tara Westover considers the effects of academic and nonacademic literacies in her life. She also contemplates the ways that identification with certain literacies can both create and disturb an individual's relationships and community memberships. While <em data-effect="italics">Educated: A Memoir</em> addresses a variety of themes&#x2014;including the tensions that family members must confront when they disagree&#x2014;the memoir can be read largely as a literacy narrative, or story about learning literacies.</p>
        </div>
        <div class="chapter-content-module" data-type="page">
          <section class="living-words" data-depth="1" id="auto_eaa09a0f-d683-44cd-870b-4205ee0ff23b_fs-idm246527104">
            <p class="annotation annotation-text culture-icon" id="auto_eaa09a0f-d683-44cd-870b-4205ee0ff23b_eip-idm372975056">From the title and from Douglass's use of the word I, you know this work is autobiographical and therefore written from the first-person point of view.</p>
          </section>
        </div>
        <div class="chapter-content-module" data-type="page">
          <section data-depth="1" id="auto_bd84c07f-d9d2-41b2-b783-16a72bd1c6d5_eip-657">
            <p class="annotation dreaming-icon" id="auto_bd84c07f-d9d2-41b2-b783-16a72bd1c6d5_eip-328">
            In this assignment, you will write an essay in which you offer a developed <strong>narrative</strong> about an aspect of your <strong>literacy</strong> practice or experience. Consider some of these questions: <em data-effect="italics"> When did this engagement occur? Where were you? Were there other participants? Have you told this story before? If so, how often, and why do you think you return to it? Has this engagement shaped your current literacy practices? Has it shaped your practices going forward?
            </em>
            </p>
          </section>
        </div>
      HTML
    )
  end

  it 'works' do
    described_class.new.bake(chapter: chapter)
    expect(chapter).to match_normalized_html(
      <<~HTML
        <div data-type="chapter">
          <div class="chapter-content-module" data-type="page">
            <p class="annotation culture-icon linguistic-icon" id="auto_c94c7ae0-0c9f-4249-817b-560d3c686ed5_fs-idm248159488">
              <div class="os-icons">
                <span class="linguistic-icon"></span>
                <span class="culture-icon"></span>
              </div>
              <span class="os-text">You, like all people, express your <span data-type="term" group-by="i" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term5">identity</span> (idea about who you are) through language. The language you use also signals the ways you are rooted in specific <span data-type="term" group-by="c" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term6">cultures</span> (groups of people who share common beliefs and lived experiences). Because the ways in which people speak and write are closely intertwined with their self-images and community affiliations, you can think, communicate, and interact most freely with others by using your personal <span data-type="term" group-by="i" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term7">idiolect</span> (your individual way of speaking and writing), which is based in <span data-type="term" group-by="c" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term8">cultural</span> language use. This section examines a few myths about language use and explores some productive ways to think about language and communication.
          </span>
            </p>
            <p class="annotation culture-icon linguistic-icon" id="auto_c94c7ae0-0c9f-4249-817b-560d3c686ed5_eip-958">
              <div class="os-icons">
                <span class="linguistic-icon"></span>
                <span class="culture-icon"></span>
              </div>
              <span class="os-text">
          Even though individuals speak and write effectively by using different varieties of English, many people nevertheless believe that one standard, &#x201C;proper&#x201D; English variety exists and that this &#x201C;correct&#x201D; way of speaking and writing should be used universally in all settings. This viewpoint considers varieties of English outside the imagined norm to be &#x201C;wrong,&#x201D; &#x201C;bad,&#x201D; or &#x201C;substandard.&#x201D; For example, speakers of some Southern English varieties are often judged as &#x201C;poor&#x201D; or &#x201C;unintelligent.&#x201D; If you speak and write using one of those undervalued English varieties, others may have judged you for your language use or told you that your writing is &#x201C;wrong.&#x201D; Even without such judgement, you may have felt apprehensive when sharing your writing with others; you still may fear a harsh assessment, or you may feel vulnerable when others see your compositions.
          </span>
            </p>
            <p class="annotation auditory-icon kinesthetic-icon" id="auto_c94c7ae0-0c9f-4249-817b-560d3c686ed5_eip-677">
              <div class="os-icons">
                <span class="auditory-icon"></span>
                <span class="kinesthetic-icon"></span>
              </div>
              <span class="os-text">The truth is that people speak and write in different ways for different <span data-type="term" group-by="r" id="auto_page_c94c7ae0-0c9f-4249-817b-560d3c686ed5_term9">rhetorical situations</span> (instances of communication). People in different communities and professions employ distinct kinds of English. You already use different varieties of English in different parts of your life; as you progress through college and into your career, you will learn the language expectations for the rhetorical situations you will encounter in those spaces. In learning these expectations, you will gain new identities. For example, you may become someone who knows how to write an exemplary lab report, you could develop an identity as an emerging researcher in any number of fields, or you simply may become someone who is comfortable letting other people see your writing. These new linguistic identities do not need to replace your language use in other areas of your life. For instance, you should not feel the need to use a different form of grammar or punctuation in your social media posts. You should feel comfortable using your familiar English varieties in familiar rhetorical situations and, if needed, use new varieties of English you may learn in the new rhetorical situations you encounter. Additionally, you can, and should, seek out opportunities to use your familiar, nonacademic English varieties in academic and professional settings when you feel it is appropriate and aligns with the expectations of your instructor or employer.
          </span>
            </p>
            <p class="annotation dreaming-icon speech-icon visual-icon" id="auto_c94c7ae0-0c9f-4249-817b-560d3c686ed5_eip-61">
              <div class="os-icons">
                <span class="dreaming-icon"></span>
                <span class="visual-icon"></span>
                <span class="speech-icon"></span>
              </div>
              <span class="os-text">Because people write in many different settings for many reasons, no particular English variety is appropriate for all writing tasks. As you become more familiar with the ways English is used in different settings and communities, you can choose which variety to use. You also may choose whether to meet or to disrupt the expectations of the people you are communicating with. In making these choices, you will rely on your existing literacies as well as newly learned ones.
          </span>
            </p>
          </div>
          <div class="chapter-content-module" data-type="page">
            <p class="annotation culture-icon linguistic-icon" id="auto_b8ea2055-f5a8-444d-a114-b4afbd2dfee5_fs-idm370565488">
              <div class="os-icons">
                <span class="linguistic-icon"></span>
                <span class="culture-icon"></span>
              </div>
              <span class="os-text">In her 2018 best seller, <em data-effect="italics">Educated: A Memoir</em>, Tara Westover considers the effects of academic and nonacademic literacies in her life. She also contemplates the ways that identification with certain literacies can both create and disturb an individual's relationships and community memberships. While <em data-effect="italics">Educated: A Memoir</em> addresses a variety of themes&#x2014;including the tensions that family members must confront when they disagree&#x2014;the memoir can be read largely as a literacy narrative, or story about learning literacies.</span>
            </p>
          </div>
          <div class="chapter-content-module" data-type="page">
            <section class="living-words" data-depth="1" id="auto_eaa09a0f-d683-44cd-870b-4205ee0ff23b_fs-idm246527104">
              <p class="annotation annotation-text culture-icon" id="auto_eaa09a0f-d683-44cd-870b-4205ee0ff23b_eip-idm372975056">
                <div class="os-icons">
                  <span class="culture-icon"></span>
                </div>
                <span class="os-text">From the title and from Douglass's use of the word I, you know this work is autobiographical and therefore written from the first-person point of view.</span>
              </p>
            </section>
          </div>
          <div class="chapter-content-module" data-type="page">
            <section data-depth="1" id="auto_bd84c07f-d9d2-41b2-b783-16a72bd1c6d5_eip-657">
              <p class="annotation dreaming-icon" id="auto_bd84c07f-d9d2-41b2-b783-16a72bd1c6d5_eip-328">
                <div class="os-icons">
                  <span class="dreaming-icon"></span>
                </div>
                <span class="os-text">
            In this assignment, you will write an essay in which you offer a developed <strong>narrative</strong> about an aspect of your <strong>literacy</strong> practice or experience. Consider some of these questions: <em data-effect="italics"> When did this engagement occur? Where were you? Were there other participants? Have you told this story before? If so, how often, and why do you think you return to it? Has this engagement shaped your current literacy practices? Has it shaped your practices going forward?
            </em>
            </span>
              </p>
            </section>
          </div>
        </div>
      HTML
    )
  end

end
