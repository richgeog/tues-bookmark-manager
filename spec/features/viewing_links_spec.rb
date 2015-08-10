require './data_mapper_setup'
require 'spec_helper'

feature 'Viewing links' do

  scenario 'the hompage has the link to the database' do
    Link.new(url: 'http://www.makersacademy.com', title: 'Makers Academy')
    visit '/links'
    expect(page.status_code).to eq 200
    within 'ul#links' do
      expect(page).to have_content('Makers Academy')
    end
  end
end