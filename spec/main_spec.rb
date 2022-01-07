# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'books' do
  xit 'bakes dummy' do
    expect('dummy').to bake_correctly
  end

  xit 'bakes accounting' do
    expect('accounting').to bake_correctly
  end

  xit 'bakes additive-manufacturing' do
    expect('additive-manufacturing').to bake_correctly
  end

  xit 'bakes american-government' do
    expect('american-government').to bake_correctly
  end

  xit 'bakes anatomy' do
    expect('anatomy').to bake_correctly
  end

  xit 'bakes anthropology' do
    expect('anthropology').to bake_correctly
  end

  xit 'bakes ap bio' do
    expect('ap-biology').to bake_correctly
  end

  xit 'bakes ap history' do
    expect('ap-history').to bake_correctly
  end

  xit 'bakes astronomy' do
    expect('astronomy').to bake_correctly
  end

  xit 'bakes bca' do
    expect('bca').to bake_correctly
  end

  xit 'bakes biology' do
    expect('biology').to bake_correctly
  end

  xit 'bakes business ethics' do
    expect('business-ethics').to bake_correctly
  end

  xit 'bakes business law' do
    expect('business-law').to bake_correctly_with('business-ethics')
  end

  xit 'bakes calculus' do
    expect('calculus').to bake_correctly
  end

  xit 'bakes chemistry' do
    expect('chemistry').to bake_correctly
  end

  xit 'bakes college algebra' do
    expect('college-algebra').to bake_correctly_with('precalculus')
  end

  xit 'bakes college algebra coreq' do
    expect('college-algebra-coreq').to bake_correctly_with('precalculus-coreq')
  end

  xit 'bakes college physics' do
    expect('college-physics').to bake_correctly
  end

  xit 'bakes college success' do
    expect('college-success').to bake_correctly
  end

  xit 'bakes computer science' do
    expect('computer-science').to bake_correctly
  end

  xit 'bakes contemporary-math' do
    expect('contemporary-math').to bake_correctly
  end

  xit 'bakes economics' do
    expect('economics').to bake_correctly
  end

  xit 'bakes elementary algebra' do
    expect('elementary-algebra').to bake_correctly_with('dev-math')
  end

  xit 'bakes english-composition' do
    expect('english-composition').to bake_correctly
  end

  xit 'bakes entrepreneurship' do
    expect('entrepreneurship').to bake_correctly
  end

  xit 'bakes finance' do
    expect('finance').to bake_correctly
  end

  xit 'bakes history' do
    expect('history').to bake_correctly
  end

  xit 'bakes hs-physics' do
    expect('hs-physics').to bake_correctly
  end

  xit 'bakes intellectual property' do
    expect('intellectual-property').to bake_correctly_with('business-ethics')
  end

  xit 'bakes intermediate algebra' do
    expect('intermediate-algebra').to bake_correctly_with('dev-math')
  end

  xit 'bakes intro business' do
    expect('intro-business').to bake_correctly
  end

  xit 'bakes microbio' do
    expect('microbiology').to bake_correctly
  end

  it 'bakes organizational-behavior' do
    expect('organizational-behavior').to bake_correctly_with('principles-management')
  end

  xit 'bakes philosophy' do
    expect('philosophy').to bake_correctly
  end

  xit 'bakes pl-psychology' do
    expect('pl-psychology').to bake_correctly
  end

  xit 'bakes pl u-physics' do
    expect('pl-u-physics').to bake_correctly
  end

  xit 'bakes political science' do
    expect('political-science').to bake_correctly
  end

  xit 'bakes prealgebra' do
    expect('prealgebra').to bake_correctly_with('dev-math')
  end

  xit 'bakes precalculus' do
    expect('precalculus').to bake_correctly
  end

  it 'bakes principles-management' do
    expect('principles-management').to bake_correctly
  end

  xit 'bakes psychology' do
    expect('psychology').to bake_correctly
  end

  xit 'bakes sociology' do
    expect('sociology').to bake_correctly
  end

  xit 'bakes statistics' do
    expect('statistics').to bake_correctly
  end

  xit 'bakes trigonometry' do
    expect('trigonometry').to bake_correctly_with('precalculus')
  end

  xit 'bakes u-physics' do
    expect('u-physics').to bake_correctly
  end

  xit 'bakes world-histrory' do
    expect('world-history').to bake_correctly
  end

  # ATTENTION: SPECS ARE NOW ALPHABETIZED
  # pls add future specs into the alphabet instead of here (unless the book starts with x-z)
  # thanks <3
end
