# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'books' do
  it 'bakes dummy' do
    expect('dummy').to bake_correctly
  end

  it 'bakes accounting' do
    expect('accounting').to bake_correctly
  end

  it 'bakes additive-manufacturing' do
    expect('additive-manufacturing').to bake_correctly
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
    expect('business-law').to bake_correctly_with('business-ethics')
  end

  it 'bakes calculus' do
    expect('calculus').to bake_correctly
  end

  it 'bakes chemistry' do
    expect('chemistry').to bake_correctly
  end

  it 'bakes college algebra' do
    expect('college-algebra').to bake_correctly_with('precalculus')
  end

  it 'bakes college algebra coreq' do
    expect('college-algebra-coreq').to bake_correctly_with('precalculus-coreq')
  end

  it 'bakes college physics' do
    expect('college-physics').to bake_correctly
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
    expect('elementary-algebra').to bake_correctly_with('dev-math')
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

  it 'bakes hs-physics' do
    expect('hs-physics').to bake_correctly
  end

  it 'bakes intellectual property' do
    expect('intellectual-property').to bake_correctly_with('business-ethics')
  end

  it 'bakes intermediate algebra' do
    expect('intermediate-algebra').to bake_correctly_with('dev-math')
  end

  it 'bakes intro business' do
    expect('intro-business').to bake_correctly
  end

  it 'bakes microbio' do
    expect('microbiology').to bake_correctly
  end

  it 'bakes philosophy' do
    expect('philosophy').to bake_correctly
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
    expect('prealgebra').to bake_correctly_with('dev-math')
  end

  it 'bakes precalculus' do
    expect('precalculus').to bake_correctly
  end

  it 'bakes psychology' do
    expect('psychology').to bake_correctly
  end

  it 'bakes sociology' do
    expect('sociology').to bake_correctly
  end

  it 'bakes statistics' do
    expect('statistics').to bake_correctly
  end

  it 'bakes trigonometry' do
    expect('trigonometry').to bake_correctly_with('precalculus')
  end

  it 'bakes u-physics' do
    expect('u-physics').to bake_correctly
  end

  it 'bakes world-histrory' do
    expect('world-history').to bake_correctly
  end
end
