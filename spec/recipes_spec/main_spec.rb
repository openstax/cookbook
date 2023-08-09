# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'books' do
  it 'bakes dummy' do
    expect('dummy').to bake_correctly_with_resources('/../books/dummy/resources')
  end

  it 'bakes accounting' do
    expect('accounting').to bake_correctly
  end

  it 'bakes american-government' do
    expect('american-government').to bake_correctly
  end

  it 'bakes anatomy' do
    expect('anatomy').to bake_correctly
  end

  it 'bakes anthropology' do
    expect('anthropology').to bake_correctly
  end

  it 'bakes ap bio' do
    expect('ap-biology').to bake_correctly
  end

  it 'bakes ap history' do
    expect('ap-history').to bake_correctly
  end

  it 'bakes ap physics' do
    expect('ap-physics').to bake_correctly
  end

  it 'bakes ap physics 2e' do
    expect('ap-physics-2e').to bake_correctly
  end

  it 'bakes astronomy' do
    expect('astronomy').to bake_correctly
  end

  it 'bakes bca' do
    expect('bca').to bake_correctly
  end

  it 'bakes biology' do
    expect('biology').to bake_correctly
  end

  it 'bakes business ethics' do
    expect('business-ethics').to bake_correctly
  end

  it 'bakes business law' do
    expect('business-law').to bake_correctly_with_recipe('business-ethics')
  end

  it 'bakes calculus' do
    expect('calculus').to bake_correctly
  end

  it 'bakes chemistry' do
    expect('chemistry').to bake_correctly
  end

  it 'bakes college algebra' do
    expect('college-algebra').to bake_correctly_with_recipe('precalculus')
  end

  it 'bakes college algebra coreq' do
    expect('college-algebra-coreq').to bake_correctly_with_recipe('precalculus-coreq')
  end

  it 'bakes college physics' do
    expect('college-physics').to bake_correctly
  end

  it 'bakes college physics 2e' do
    expect('college-physics-2e').to bake_correctly
  end

  it 'bakes college success' do
    expect('college-success').to bake_correctly
  end

  it 'bakes computer science' do
    expect('computer-science').to bake_correctly
  end

  it 'bakes contemporary-math' do
    expect('contemporary-math').to bake_correctly
  end

  it 'bakes economics' do
    expect('economics').to bake_correctly
  end

  it 'bakes elementary algebra' do
    expect('elementary-algebra').to bake_correctly_with_recipe('dev-math')
  end

  it 'bakes english-composition' do
    expect('english-composition').to bake_correctly
  end

  it 'bakes entrepreneurship' do
    expect('entrepreneurship').to bake_correctly
  end

  it 'bakes finance' do
    expect('finance').to bake_correctly
  end

  it 'bakes history' do
    expect('history').to bake_correctly
  end

  it 'bakes hs college success' do
    expect('hs-college-success').to bake_correctly
  end

  it 'bakes hs-physics' do
    expect('hs-physics').to bake_correctly
  end

  it 'bakes intellectual property' do
    expect('intellectual-property').to bake_correctly_with_recipe('business-ethics')
  end

  it 'bakes intermediate algebra' do
    expect('intermediate-algebra').to bake_correctly_with_recipe('dev-math')
  end

  it 'bakes intro business' do
    expect('intro-business').to bake_correctly
  end

  it 'bakes marketing' do
    expect('marketing').to bake_correctly
  end

  it 'bakes microbio' do
    expect('microbiology').to bake_correctly
  end

  it 'bakes nursing-external' do
    expect('nursing-external').to bake_correctly
  end

  it 'bakes nursing-internal' do
    expect('nursing-internal').to bake_correctly
  end

  it 'bakes organic-chemistry' do
    expect('organic-chemistry').to bake_correctly
  end

  it 'bakes organizational-behavior' do
    expect('organizational-behavior').to bake_correctly_with_recipe('principles-management')
  end

  it 'bakes philosophy' do
    expect('philosophy').to bake_correctly
  end

  it 'bakes pl-microeconomics' do
    expect('pl-microeconomics').to bake_correctly_with_recipe('pl-economics')
  end

  it 'bakes pl-psychology' do
    expect('pl-psychology').to bake_correctly
  end

  it 'bakes pl u-physics' do
    expect('pl-u-physics').to bake_correctly
  end

  it 'bakes political science' do
    expect('political-science').to bake_correctly
  end

  it 'bakes prealgebra' do
    expect('prealgebra').to bake_correctly_with_recipe('dev-math')
  end

  it 'bakes precalculus' do
    expect('precalculus').to bake_correctly
  end

  it 'bakes principles-management' do
    expect('principles-management').to bake_correctly
  end

  it 'bakes psychology' do
    expect('psychology').to bake_correctly
  end

  it 'bakes python' do
    expect('python').to bake_correctly
  end

  it 'bakes sociology' do
    expect('sociology').to bake_correctly
  end

  it 'bakes statistics' do
    expect('statistics').to bake_correctly
  end

  it 'bakes trigonometry' do
    expect('trigonometry').to bake_correctly_with_recipe('precalculus')
  end

  it 'bakes u-physics' do
    expect('u-physics').to bake_correctly
  end

  it 'bakes world-histrory' do
    expect('world-history').to bake_correctly
  end

  # ATTENTION: SPECS ARE NOW ALPHABETIZED
  # please add future specs in alphabetical order
end
