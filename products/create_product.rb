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
	end

	after(:each) do
		@driver.quit
		@verification_errors.should == []
	end

	it "test_create_product" do
		@driver.get(@base_url + "/node/add/product")
		@driver.find_element(:link, "Product").click
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

		@driver.find_element(:id, "edit-taxonomy-tags-7").click
		@driver.find_element(:id, "edit-taxonomyextra-und").clear
		@driver.find_element(:id, "edit-taxonomyextra-und").send_keys "Crystal, Swarovski"
		@driver.find_element(:id, "edit-field-image-cache-und-0-upload").click
		@driver.find_element(:id, "edit-field-image-cache-und-0-upload").clear
		@driver.find_element(:id, "edit-field-image-cache-und-0-upload").send_keys "/Users/ragavendra.nagraj/Desktop/product.png"
		@driver.find_element(:id, "edit-model").clear
		@driver.find_element(:id, "edit-model").send_keys "FJ_SWAROLEAF"
		@driver.find_element(:id, "edit-sell-price").clear
		@driver.find_element(:id, "edit-sell-price").send_keys "200"
		@driver.find_element(:id, "edit-weight").clear
		@driver.find_element(:id, "edit-weight").send_keys "100"
		@driver.find_element(:id, "edit-submit").click
		# Warning: verifyTextPresent may require manual changes
		verify { @driver.find_element(:css, "BODY").text.should =~ /^[\s\S]*Product Swarovski Crystal Leaf has been created\.[\s\S]*$/ }
	end

	def element_present?(how, what)
		${receiver}.find_element(how, what)
		true
	rescue Selenium::WebDriver::Error::NoSuchElementError
		false
	end

	def alert_present?()
		${receiver}.switch_to.alert
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
		alert = ${receiver}.switch_to().alert()
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

