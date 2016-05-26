
#Usage - '$rspec CRM_rspec.rb'

require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "CreateProduct" do

	before(:each) do
		@driver = Selenium::WebDriver.for :firefox
		@base_url = "http://www.fashionjewelry.co.in/"
		@accept_next_alert = true
		@driver.manage.timeouts.implicit_wait = 30
		@verification_errors = []
		@driver.manage.window.maximize
	end

	after(:each) do
		#@driver.quit
		@verification_errors.should == []
	end
=begin
	it "login" do
		@driver.get(@base_url)
		#@driver.find_element(:id, "edit-name").clear
		@driver.find_element(:id, "edit-name").send_keys ENV['USER']
		@driver.find_element(:id, "edit-pass").send_keys ENV['PASSWD']
		@driver.find_element(:id, "edit-submit").click
	end
=end		
	it "test_create_product" do
		@driver.get(@base_url)
		#@driver.find_element(:id, "edit-name").clear
		@driver.find_element(:id, "edit-name").send_keys ENV['USER']
		@driver.find_element(:id, "edit-pass").send_keys ENV['PASSWD']
		@driver.find_element(:id, "edit-submit").click
		
		@driver.get(@base_url + "/node/add/product")
		#@driver.find_element(:link, "Product").click
		@driver.find_element(:id, "edit-title").clear
		@driver.find_element(:id, "edit-title").send_keys "Swarovski Crystal Leaf title"
		@driver.find_element(:id, "edit-body-und-0-value").click
		@driver.find_element(:id, "edit-body-und-0-value").clear
		@driver.find_element(:id, "edit-body-und-0-value").send_keys "Swarovski Crystal Leaf description should go here"
		# ERROR: Caught exception [ERROR: Unsupported command [addSelection | id=edit-taxonomy-catalog-und | label=Jewelry Set]]
		value = "Jewelry Set"
		my_select = @driver.find_element(:id, "edit-taxonomy-catalog-und")
		my_select.click
		my_select.find_elements( :tag_name => "option" ).find do |option|
			  option.text == value
		end.click
=begin
		@driver.find_element(:id, "edit-field-image-cache-und-0-upload").location_once_scrolled_into_view
		@driver.find_element(:id, "edit-field-image-cache-und-0-upload").click
		@driver.find_element(:id, "edit-field-image-cache-und-0-upload").send_keys "/Users/ragavendra.nagraj/Desktop/product.png"
=end
		#@driver.find_element(:id, "edit-taxonomy-tags-7").click
		@driver.find_element(:id, "edit-taxonomyextra-und").clear
		@driver.find_element(:id, "edit-taxonomyextra-und").send_keys "Crystal, Swarovski"

		#require 'pry'
		#binding.pry

		@driver.find_element(:id, "edit-model").clear
		@driver.find_element(:id, "edit-model").send_keys "FJ_SWAROLEAF"
		@driver.find_element(:id, "edit-sell-price").clear
		@driver.find_element(:id, "edit-sell-price").send_keys "200"
		@driver.find_element(:id, "edit-weight--2").clear
		@driver.find_element(:id, "edit-weight--2").send_keys "100"
		#@driver.find_element(:id, "edit-list-price").location_once_scrolled_into_view
		#@driver.find_element(:id, "edit-model").location_once_scrolled_into_view
		#@driver.find_element(:id, "edit-submit").clear
		@driver.find_element(:id, "edit-submit").click
		# Warning: verifyTextPresent may require manual changes
		verify { @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Product Swarovski Crystal Leaf has been created\.[\s\S]*$/ }
	end

	def element_present?(how, what)
		@driver.find_element(how, what)
		true
	rescue Selenium::WebDriver::Error::NoSuchElementError
		false
	end

	def alert_present?()
		@driver.switch_to.alert
		true
	rescue Selenium::WebDriver::Error::NoAlertPresentError
		false
	end

	def verify(&blk)
		yield
	rescue ExpectationNotMetError => ex
		@verification_errors << ex
	end

	def close_alert_and_get_its_text(how, what)
		alert = @driver.switch_to().alert()
		alert_text = alert.text
		if (@accept_next_alert) then
			alert.accept()
		else
			alert.dismiss()
		end
		alert_text
	ensure
		@accept_next_alert = true
	end
end

=begin
#Usage - '$rspec CRM_rspec.rb'

require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "CRMRuby" do

	before(:each) do
		@driver = Selenium::WebDriver.for :firefox
		@base_url = "https://adfs.mogo.ca/"
		@accept_next_alert = true
		@driver.manage.timeouts.implicit_wait = 30
		@verification_errors = []
	end

	after(:each) do
		@driver.quit
		@verification_errors.should == []
	end

	it "test_c_r_m_ruby" do
		@driver.get(@base_url + "/adfs/ls/?wa=wsignin1.0&wtrealm=https%3a%2f%2fmscr-uat.mogo.ca%2f&wctx=rm%3d1%26id%3ddc068ce8-8298-4aba-bab5-2c350b6ed879%26ru%3dhttps%253a%252f%252fmscr-uat.mogo.ca%252fmain.aspx&wct=2015-12-10T21%3a48%3a19Z&wauth=urn%3aoasis%3anames%3atc%3aSAML%3a1.0%3aam%3apassword#154964165")
		@driver.find_element(:id, "userNameInput").clear
		@driver.find_element(:id, "userNameInput").send_keys "mogo\\SVC-MSCR-SOA"
		@driver.find_element(:id, "passwordInput").clear
		@driver.find_element(:id, "passwordInput").send_keys "aZJbhM6Y#m[P={(!v2R(bw~+JjM5rBsw"
		@driver.find_element(:id, "submitButton").click
		# ERROR: Caught exception [ERROR: Unsupported command [selectFrame | contentIFrame0 | ]]
		# ERROR: Caught exception [ERROR: Unsupported command [selectFrame | dashboardFrame | ]]
		!60.times{ break if (element_present?(:xpath, "//table[@id='gridBodyTable']/tbody/tr[2]/td[2]/nobr") rescue false); sleep 1 }
		@driver.find_element(:id, "gridBodyTable_primaryField_{396760E2-6D62-E511-80FA-061277C79625}_1").click
		# ERROR: Caught exception [ERROR: Unsupported command [selectWindow | name=contentIFrame0 | ]]
		!60.times{ break if (element_present?(:css, "h1.ms-crm-TextAutoEllipsis") rescue false); sleep 1 }
		# ERROR: Caught exception [ERROR: Unsupported command [selectWindow | name=contentIFrame0 | ]]
		verify { (@driver.find_element(:css, "h1.ms-crm-TextAutoEllipsis").text).should == "Aaron Gill" }
		!60.times{ break if (element_present?(:css, "span.navTabButtonUserInfoText.navTabButtonUserInfoCompany") rescue false); sleep 1 }
		@driver.find_element(:css, "span.navTabButtonUserInfoText.navTabButtonUserInfoCompany").click
		@driver.find_element(:id, "navTabButtonUserInfoSignOutId").click
	end

	def element_present?(how, what)
		@driver.find_element(how, what)
		true
	rescue Selenium::WebDriver::Error::NoSuchElementError
		false
	end

	def alert_present?()
=end
