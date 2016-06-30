
#Usage - '$rspec CRM_rspec.rb'

require 'csv'
require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "CreateProduct" do

	before(:each) do
		@driver = Selenium::WebDriver.for :firefox
		@base_url = "http://www.fashionjewelry.co.in/"
		#@base_url = "http://192.168.44.45/jewelry"
		@accept_next_alert = true
		@driver.manage.timeouts.implicit_wait = 30
		@verification_errors = []
		@driver.manage.window.maximize
	end

	after(:each) do
		#@driver.quit
		#@verification_errors.should == []
		expect @verification_errors == []
	end

	it "test_create_product" do
		@driver.get(@base_url)
		#@driver.find_element(:id, "edit-name").clear
		@driver.find_element(:id, "edit-name").send_keys ENV['USER']
		@driver.find_element(:id, "edit-pass").send_keys ENV['PASSWD']
		@driver.find_element(:id, "edit-submit").click
		
		CSV.foreach(File.join(File.dirname(__FILE__), 'products_1.csv')) do |row|
		@driver.get(@base_url + "/node/add/product")
		@driver.find_element(:id, "edit-title").clear
		@driver.find_element(:id, "edit-title").send_keys row[0]
		@driver.find_element(:id, "edit-body-und-0-value").click
		@driver.find_element(:id, "edit-body-und-0-value").clear
		@driver.find_element(:id, "edit-body-und-0-value").send_keys row[1]
		
		#value = "Jewelry Set"
		my_select = @driver.find_element(:id, "edit-taxonomy-catalog-und")
		my_select.find_elements( :tag_name => "option" ).find do |option|
			  option.text == row[2]
		end.click
	
		index = 0
		3.times do
			if row[index]
				@driver.find_element(:id, "edit-body-und-0-value").location_once_scrolled_into_view
			
				break unless row[index + 7]
				file_path = File.join(File.dirname(__FILE__), row[index + 7]) 
				#require 'pry'
				#binding.pry
				sleep 1
				@driver.find_element(:id, "edit-field-image-cache-und-#{index}-upload").send_keys file_path
				
				sleep 1
				WaitForObject(@driver, :name, "field_image_cache_und_#{index}_upload_button")
				#@driver.find_element(:name, "field_image_cache_und_#{index}_upload_button").location_once_scrolled_into_view
				@driver.find_element(:name, "field_image_cache_und_#{index}_upload_button").click
				
				sleep 1
				index = index + 1
			end

		end
		
		#@driver.find_element(:id, "edit-taxonomy-tags-7").click
		@driver.find_element(:id, "edit-taxonomyextra-und").clear
		@driver.find_element(:id, "edit-taxonomyextra-und").send_keys row[3]

		@driver.find_element(:id, "edit-model").clear
		@driver.find_element(:id, "edit-model").send_keys row[4]
		@driver.find_element(:id, "edit-sell-price").clear
		@driver.find_element(:id, "edit-sell-price").send_keys row[5]
		@driver.find_element(:id, "edit-weight--2").clear
		@driver.find_element(:id, "edit-weight--2").send_keys row[6]
		@driver.find_element(:css, "#block-views-uc-products-block-1 > h2").location_once_scrolled_into_view	
		@driver.find_element(:id, "edit-pkg-qty").location_once_scrolled_into_view
		
		sleep 3

		@driver.find_element(:id, "edit-submit").click
		sleep 10
	
		#require 'pry'
		#binding.pry

		#WaitForObject(@driver, :css, 'em.placeholder')
		WaitForObject(@driver, :css, 'div.messages.status')

		# Warning: verifyTextPresent may require manual changes
		verify { expect @driver.find_element(:css, "div.messages.status").text.eql?"Status message\nProduct #{row[0]} title has been created." }
	end
	end
	
	def WaitForObject(parent, how, what)	
		timeout = 90
		timeout.times do
			return if parent.find_element(how, what).displayed?
			sleep 1
		end
		#raise "Object not found" unless displayed
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
