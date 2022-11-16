require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))

module WithinHelpers
  def with_scope(locator)
    locator ? within(*selector_for(locator)) { yield } : yield
  end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within (.*[^:])$/ do |step, parent|
  with_scope(parent) { When step }
end

# Multi-line step scoper
When /^(.*) within (.*[^:]):$/ do |step, parent, table_or_string|
  with_scope(parent) { When "#{step}:", table_or_string }
end

Given /the following users exist/ do |users_table|
  users_table.hashes.each do |user|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that user to the database here.
    User.create(user)
  end
end

Then(/^(\d+) seed users should exist$/) do |n_seeds|
  expect(User.count).to eq n_seeds.to_i
end

Given(/^I am on home page$/) do
  visit root_path
end


When(/^I fill in "([^"]*)" with "([^"]*)" and "([^"]*)" with "([^"]*)"$/) do |field1, value1, field2, value2|
  fill_in(field1,:with => value1)
  fill_in(field2,:with => value2)
end

And(/^I press "([^"]*)"$/) do |button|
  click_button(button)
end

When(/^I follow "([^"]*)"$/) do |link|
  click_link(link)
end

Then (/^I should be on "([^"]*)"$/) do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then(/^"([^"]*)" with password "([^"]*)" should not login$/) do |username, password|
  user = User.find_by(username: username, password: password)
  expect(user).to be_nil
end


Given(/^I am on User Input page$/) do
  visit welcome_new_index_url

end

And(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, :with => value)
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then(/^I should see all the information of "([^"]*)"$/) do |username|
  user = User.find_by(username: username)
  step %{I should see "#{user.height}"}
  step %{I should see "#{user.weight}"}
  step %{I should see "#{user.sex}"}
  step %{I should see "#{user.age}"}

end


Given(/^I am on the main page of "([^"]*)"$/) do |arg|
  step %{I am on home page}
  step %{I fill in "username" with "InfinityAlpha" and "password" with "00000000"}
  step %{I press "sign in"}
  step %{I should be on "existing user main page"}
  user = User.find_by(username: arg)
end

Then(/^I should be on the edit page$/) do
  pending
end

Then(/^I should see last_name with "([^"]*)" on the main page of "([^"]*)"$/) do |arg1, arg2|
  user = User.find_by(username: arg2)
  user.last_name.should == arg1
end

Then(/^(\d+) seed restaurants should exist$/) do |n_seeds|
  pending
end

Then(/^I should see information of all restaurants$/) do
  pending
end

Then(/^I should not see "([^"]*)"$/) do |arg|
  pending
end

And(/^I select "([^"]*)" with "([^"]*)"$/) do |field, options|
  select(options, :from => field)
end