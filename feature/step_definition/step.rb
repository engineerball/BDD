Given(/^I am at "(.*?)"$/) do |url|
      @browser.goto url
end

Then(/^I be able to see text "(.*?)"$/) do |arg1|
    @browser.text.include? arg1
end

Then(/^I press "ESC" button for escape pop-up ads$/) do
   @browser.send_keys :escape
end

Then(/^Take screenshot on this page$/)do
    @browser.screenshot.save "screenshots/screenshot-#$now.png"
end
