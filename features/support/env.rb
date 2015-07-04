require 'watir-webdriver'
require 'watir-webdriver-performance'
require 'rspec/expectations'
require 'logging'
require 'digest/md5'
require 'csv'
require 'tmpdir'
require 'fileutils'
require_relative 'oscheck'


now = Time.now.strftime("%Y%m%d%H%M%S")
$now = now

logger = Logging.logger(STDOUT)
logger.level = :debug


detected_os = Oscheck.new.os.to_s
feature_name = nil
scenario_name = nil
scenario_step_count = 0
scenario_status = 0
browser = nil

if detected_os=="windows"
    browser = Watir::Browser.new :firefox, :service_log_path => 'chromedriver.out', :switches => %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate]
elsif detected_os=="linux"
    require 'headless'
    $headless = Headless.new
    $headless.start
    driver = Selenium::WebDriver.for :firefox
    browser = Watir::Browser.new driver
else
    logger.error "The current OS (#{deteced_os}) is not support."
    exit
end
browser.driver.manage.timeouts.implicit_wait = 45

Before do |scenario|
    @browser = browser
    @logger = logger

 #feature name
  case scenario
    when Cucumber::Ast::Scenario
      feature_name = scenario.feature.name
    when Cucumber::Ast::OutlineTable::ExampleRow
      feature_name = scenario.scenario_outline.feature.name
  end

  # Scenario name
  case scenario
    when Cucumber::Ast::Scenario
      scenario_name = scenario.name
    when Cucumber::Ast::OutlineTable::ExampleRow
      scenario_name = scenario.scenario_outline.name
  end
  @sc = scenario
  #logger.debug "SCENARIO-NAME: #{scenario_name}"
end

AfterStep do |scenario|
    scenario_step_count += 1
end

After do |scenario|
    scenario_status = 1 if scenario.passed?
end

#Get last modify file
def last_modified_in dir
  Dir.glob( File.join( dir,'*' ) ).
  select  {|f| File.file? f }.
  sort_by {|f| File.mtime f }.
  last
end

last_image = last_modified_in 'screenshots/'

at_exit do

#cmd = "go run bin/compareimage.go #{last_image} screenshots/screenshot-#$now.png"
#compare_result = `#{cmd}`
#result = compare_result.gsub! 'Image difference: ',''
#result = result.tr("\n","")
#result = result.tr("\"","")
#p result
## Send result to phant
#sender = "/usr/bin/curl \"http://172.17.181.174:8080/input/Vb3AdGwk91FyAdVBpmlguWEV6oA?private_key=769G3ALjDKsAaVbK5DWgCxD0PEN&different=#{result}\""
#sender_result = `#{sender}`
    if ENV['HEADLESS']
        headless.destroy
    else
      browser.close
  end
end
