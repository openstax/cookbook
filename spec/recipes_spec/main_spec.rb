# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'books' do
  it 'bakes dummy' do
    cmd = form_bake_cmd(book: 'dummy')
    expect('dummy').to match_expected_when_baked_with(cmd)
  end

  it 'bakes accounting' do
    cmd = form_bake_cmd(book: 'accounting')
    expect('accounting').to match_expected_when_baked_with(cmd)
  end

  it 'bakes american-government' do
    cmd = form_bake_cmd(book: 'american-government')
    expect('american-government').to match_expected_when_baked_with(cmd)
  end

  it 'bakes anatomy' do
    cmd = form_bake_cmd(book: 'anatomy')
    expect('anatomy').to match_expected_when_baked_with(cmd)
  end

  it 'bakes anthropology' do
    cmd = form_bake_cmd(book: 'anthropology')
    expect('anthropology').to match_expected_when_baked_with(cmd)
  end

  it 'bakes ap bio' do
    cmd = form_bake_cmd(book: 'ap-biology')
    expect('ap-biology').to match_expected_when_baked_with(cmd)
  end

  it 'bakes ap history' do
    cmd = form_bake_cmd(book: 'ap-history')
    expect('ap-history').to match_expected_when_baked_with(cmd)
  end

  it 'bakes ap physics' do
    cmd = form_bake_cmd(book: 'ap-physics')
    expect('ap-physics').to match_expected_when_baked_with(cmd)
  end

  it 'bakes ap physics 2e' do
    cmd = form_bake_cmd(book: 'ap-physics-2e')
    expect('ap-physics-2e').to match_expected_when_baked_with(cmd)
  end

  it 'bakes astronomy' do
    cmd = form_bake_cmd(book: 'astronomy')
    expect('astronomy').to match_expected_when_baked_with(cmd)
  end

  it 'bakes bca' do
    cmd = form_bake_cmd(book: 'bca')
    expect('bca').to match_expected_when_baked_with(cmd)
  end

  it 'bakes biology' do
    cmd = form_bake_cmd(book: 'biology')
    expect('biology').to match_expected_when_baked_with(cmd)
  end

  it 'bakes business ethics' do
    cmd = form_bake_cmd(book: 'business-ethics')
    expect('business-ethics').to match_expected_when_baked_with(cmd)
  end

  it 'bakes business law' do
    cmd = form_bake_cmd(book: 'business-law', recipe: 'business-ethics')
    expect('business-law').to match_expected_when_baked_with(cmd)
  end

  it 'bakes calculus' do
    cmd = form_bake_cmd(book: 'calculus')
    expect('calculus').to match_expected_when_baked_with(cmd)
  end

  it 'bakes chemistry' do
    cmd = form_bake_cmd(book: 'chemistry')
    expect('chemistry').to match_expected_when_baked_with(cmd)
  end

  it 'bakes college algebra' do
    cmd = form_bake_cmd(book: 'college-algebra', recipe: 'precalculus')
    expect('college-algebra').to match_expected_when_baked_with(cmd)
  end

  it 'bakes college algebra coreq' do
    cmd = form_bake_cmd(book: 'college-algebra-coreq', recipe: 'precalculus-coreq')
    expect('college-algebra-coreq').to match_expected_when_baked_with(cmd)
  end

  it 'bakes college physics' do
    cmd = form_bake_cmd(book: 'college-physics')
    expect('college-physics').to match_expected_when_baked_with(cmd)
  end

  it 'bakes college physics 2e' do
    cmd = form_bake_cmd(book: 'college-physics-2e')
    expect('college-physics-2e').to match_expected_when_baked_with(cmd)
  end

  it 'bakes college success' do
    cmd = form_bake_cmd(book: 'college-success')
    expect('college-success').to match_expected_when_baked_with(cmd)
  end

  it 'bakes computer science' do
    cmd = form_bake_cmd(book: 'computer-science')
    expect('computer-science').to match_expected_when_baked_with(cmd)
  end

  it 'bakes contemporary-math' do
    cmd = form_bake_cmd(book: 'contemporary-math')
    expect('contemporary-math').to match_expected_when_baked_with(cmd)
  end

  it 'bakes data science' do
    cmd = form_bake_cmd(book: 'data-science')
    expect('data-science').to match_expected_when_baked_with(cmd)
  end

  it 'bakes economics' do
    cmd = form_bake_cmd(book: 'economics')
    expect('economics').to match_expected_when_baked_with(cmd)
  end

  it 'bakes elementary algebra' do
    cmd = form_bake_cmd(book: 'elementary-algebra', recipe: 'dev-math')
    expect('elementary-algebra').to match_expected_when_baked_with(cmd)
  end

  it 'bakes english-composition' do
    cmd = form_bake_cmd(book: 'english-composition')
    expect('english-composition').to match_expected_when_baked_with(cmd)
  end

  it 'bakes entrepreneurship' do
    cmd = form_bake_cmd(book: 'entrepreneurship')
    expect('entrepreneurship').to match_expected_when_baked_with(cmd)
  end

  it 'bakes finance' do
    cmd = form_bake_cmd(book: 'finance')
    expect('finance').to match_expected_when_baked_with(cmd)
  end

  it 'bakes history' do
    cmd = form_bake_cmd(book: 'history')
    expect('history').to match_expected_when_baked_with(cmd)
  end

  it 'bakes hs college success' do
    cmd = form_bake_cmd(book: 'hs-college-success')
    expect('hs-college-success').to match_expected_when_baked_with(cmd)
  end

  it 'bakes hs-physics' do
    cmd = form_bake_cmd(book: 'hs-physics')
    expect('hs-physics').to match_expected_when_baked_with(cmd)
  end

  it 'bakes intellectual property' do
    cmd = form_bake_cmd(book: 'intellectual-property', recipe: 'business-ethics')
    expect('intellectual-property').to match_expected_when_baked_with(cmd)
  end

  it 'bakes intermediate algebra' do
    cmd = form_bake_cmd(book: 'intermediate-algebra', recipe: 'dev-math')
    expect('intermediate-algebra').to match_expected_when_baked_with(cmd)
  end

  it 'bakes intro business' do
    cmd = form_bake_cmd(book: 'intro-business')
    expect('intro-business').to match_expected_when_baked_with(cmd)
  end

  it 'bakes lifespan development' do
    cmd = form_bake_cmd(book: 'lifespan-development')
    expect('lifespan-development').to match_expected_when_baked_with(cmd)
  end

  it 'bakes marketing' do
    cmd = form_bake_cmd(book: 'marketing')
    expect('marketing').to match_expected_when_baked_with(cmd)
  end

  it 'bakes microbio' do
    cmd = form_bake_cmd(book: 'microbiology')
    expect('microbiology').to match_expected_when_baked_with(cmd)
  end

  it 'bakes neuroscience' do
    cmd = form_bake_cmd(book: 'neuroscience')
    expect('neuroscience').to match_expected_when_baked_with(cmd)
  end

  it 'bakes nursing-external' do
    cmd = form_bake_cmd(book: 'nursing-external')
    expect('nursing-external').to match_expected_when_baked_with(cmd)
  end

  it 'bakes nursing-internal' do
    cmd = form_bake_cmd(book: 'nursing-internal')
    expect('nursing-internal').to match_expected_when_baked_with(cmd)
  end

  it 'bakes organic-chemistry' do
    cmd = form_bake_cmd(book: 'organic-chemistry')
    expect('organic-chemistry').to match_expected_when_baked_with(cmd)
  end

  it 'bakes organizational-behavior' do
    cmd = form_bake_cmd(book: 'organizational-behavior', recipe: 'principles-management')
    expect('organizational-behavior').to match_expected_when_baked_with(cmd)
  end

  it 'bakes philosophy' do
    cmd = form_bake_cmd(book: 'philosophy')
    expect('philosophy').to match_expected_when_baked_with(cmd)
  end

  it 'bakes pl-marketing' do
    cmd = form_bake_cmd(book: 'pl-marketing')
    expect('pl-marketing').to match_expected_when_baked_with(cmd)
  end

  it 'bakes pl-microeconomics' do
    cmd = form_bake_cmd(book: 'pl-microeconomics', recipe: 'pl-economics')
    expect('pl-microeconomics').to match_expected_when_baked_with(cmd)
  end

  it 'bakes pl-psychology' do
    cmd = form_bake_cmd(book: 'pl-psychology')
    expect('pl-psychology').to match_expected_when_baked_with(cmd)
  end

  it 'bakes pl u-physics' do
    cmd = form_bake_cmd(book: 'pl-u-physics')
    expect('pl-u-physics').to match_expected_when_baked_with(cmd)
  end

  it 'bakes political science' do
    cmd = form_bake_cmd(book: 'political-science')
    expect('political-science').to match_expected_when_baked_with(cmd)
  end

  it 'bakes prealgebra' do
    cmd = form_bake_cmd(book: 'prealgebra', recipe: 'dev-math')
    expect('prealgebra').to match_expected_when_baked_with(cmd)
  end

  it 'bakes precalculus' do
    cmd = form_bake_cmd(book: 'precalculus')
    expect('precalculus').to match_expected_when_baked_with(cmd)
  end

  it 'bakes principles-management' do
    cmd = form_bake_cmd(book: 'principles-management')
    expect('principles-management').to match_expected_when_baked_with(cmd)
  end

  it 'bakes psychology' do
    cmd = form_bake_cmd(book: 'psychology')
    expect('psychology').to match_expected_when_baked_with(cmd)
  end

  it 'bakes python' do
    cmd = form_bake_cmd(book: 'python')
    expect('python').to match_expected_when_baked_with(cmd)
  end

  it 'bakes sociology' do
    cmd = form_bake_cmd(book: 'sociology')
    expect('sociology').to match_expected_when_baked_with(cmd)
  end

  it 'bakes statistics' do
    cmd = form_bake_cmd(book: 'statistics')
    expect('statistics').to match_expected_when_baked_with(cmd)
  end

  it 'bakes trigonometry' do
    cmd = form_bake_cmd(book: 'trigonometry', recipe: 'precalculus')
    expect('trigonometry').to match_expected_when_baked_with(cmd)
  end

  it 'bakes u-physics' do
    cmd = form_bake_cmd(book: 'u-physics')
    expect('u-physics').to match_expected_when_baked_with(cmd)
  end

  it 'bakes world-history' do
    cmd = form_bake_cmd(book: 'world-history')
    expect('world-history').to match_expected_when_baked_with(cmd)
  end

  # ATTENTION: SPECS ARE NOW ALPHABETIZED
  # please add future specs in alphabetical order

  it 'bakes with the web pipeline on test data' do
    cmd = form_bake_cmd(
      book: 'web-test', recipe: 'dummy',
      resource_path: '../books/web-test/resources', output_platform: 'web'
    )
    expect('web-test').to match_expected_when_baked_with(cmd)
  end
end
