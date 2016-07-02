#Usage - '$rspec search/web_search.rb'

require 'csv'
require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

describe "CreateProduct" do

	before(:each) do
		@driver = Selenium::WebDriver.for :firefox
		@base_url = "http://www.fashionjewelry.co.in/"
		@google_url = "http://www.google.com/"
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

	it "test_perform_web_search" do
			
		@driver.get(@base_url + "")

		CSV.foreach(File.join(File.dirname(__FILE__), 'tags.csv')) do |row|
			@driver.find_element(:name, "as_q").clear
			#@driver.find_element(:name, "as_q").send_keys "ruby"
			@driver.find_element(:name, "as_q").send_keys row[0]
			@driver.find_element(:name, "sa").click

			sleep 5
			#require 'pry'
			#binding.pry

			#@driver.get(@google_url + "/")
		#@driver.find_element(:link_text, "Ruby | FashionJewelry").click
			# ERROR: Caught exception [ERROR: Unsupported command [selectFrame | googleSearchFrame | ]]
			#@driver.find_element(:xpath, "//div[@id='cse']/div/div/div/div[5]/div[2]/div/div/div/div/table/tbody/tr/td[2]/div/a").click
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
