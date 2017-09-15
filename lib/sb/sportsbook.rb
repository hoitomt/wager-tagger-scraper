class SB::Sportsbook

	COOKIE_PATH = "#{Rails.root}/tmp/curl_cookies/login"
	COOKIE_EXPIRATION = 1.hour

	attr_accessor :start_date, :page

	def self.get_data(config, args={})
		sb = self.new(config)
		puts "Cookie File exists #{File.exists?(sb.cookie_path)}"
		if args[:force_login]
			sb.login
		else
			sb.login if sb.expired_cookies?
		end
		puts "Cookie File exists #{File.exists?(sb.cookie_path)}"
		sb.get_wager_data(args)
	end

	def initialize(config)
		@config = config
	end

	def login
		create_cookie_path
		cmd = curl_login_cmd
		puts "SB Login Request: #{cmd}"
		`#{cmd}`
	end

	def get_wager_data(args)
		start_date = query_date(args.fetch(:start_date, Date.today))
		page = args[:page] || 1
		cmd = curl_wager_cmd(page, start_date)
		puts "SB Wager Data Request: #{cmd}"
		`#{cmd}`
	end

	def curl_login_cmd
		<<-EOF
curl --cookie #{cookie_path} --cookie-jar #{cookie_path} -L -s \
 -d "username=#{username}" \
 -d "password=#{password}" \
 -d "service=https://www.sportsbook.ag/livesports" \
 -d "login_fail=https://www.sportsbook.ag/login?service=livesports" \
 -d "sp_casinoid=7000" \
 -d "sp_siteID=7000" \
 -d "lp_casinoid=7000" \
 -d "blackbox=#{blackbox}" #{Rails.configuration.SB_LOGIN_URL}
EOF
	end

	# Always query for previous 30 days from specified start date
	# Page is zero index
	def curl_wager_cmd(page, start_date)
		<<-EOFX
curl -G --cookie #{cookie_path} -L \
 -d "betState=0" \
 -d "searchByDateType=1" \
 -d "dateRangeMode=CUSTOM" \
 -d "customDateRangeDays=30" \
 -d "customDateRangeDirection=1" \
 -d "page=#{page - 1}" \
 -d "customDateRangeDate=#{start_date}" #{Rails.configuration.SB_WAGERS_URL}
EOFX
	end

	def query_date(d)
		CGI.escape(d.strftime("%m/%d/%Y"))
	end

	def username
		@config.username
	end

	def password
		@config.password
	end

	def create_cookie_path
		FileUtils.mkdir_p COOKIE_PATH
	end

	def cookie_path
		"#{COOKIE_PATH}/cjar#{username}"
	end

	def expired_cookies?
		return true unless File.exists?(cookie_path)
		time_since_create = (Time.now - File.ctime(cookie_path))/3600
		time_since_create.hours > COOKIE_EXPIRATION
	end

	# def blackbox
	# 	@blackbox ||= `phantomjs --ignore-ssl-errors=true #{Rails.root}/lib/scripts/blackbox.js`
	# end

	def blackbox
		"0400AY1YRP7DGIANf94lis1ztioT9A1DShgA728uQ/b020dPvYhOMJICFqjrDJupThwuS7gHh9oerxrosS1xgSAgNfLEMokGoGJxLvWcZT76+Ef8LTO2h6ogWmA73rYZtIsVyoA80pXCaXbxBaD16fFhb9C1UJgA1BQZDi8R6wVNV9q0ZA6vw2gPJgovAkUyycyQhYL2vlUi+Grf+x4pw6W9ejgAxeXR6qFJvFQ3SxgXyvTx/y4JwLTE4M3VC+zK/bvD2ZBuMUapQ3wotDFEOx9IyH0A5FjuT8m29QmIvkwaq97dZKIXHvYMGl8GHmWewiSJiJMmB6s9iBRB/z5Z2W8qa0HKHY7A2Updpa6rSUQOGvHbql9jo/xz8jzmHvOZVxQkeC7EkhYzTWaVsqDg6Jo7tktezWwdrLOsKoxk0tBb1QW+xcMhBad5MO9RJsn4u3PdFTbc6ECGWCLgI+6iAxl8qhJRpdoypzbd1PXpN4zl2IQd/tZS2Kh2RLJhKS+YSimA8JeVFZcQfXdJ7TMAwER7lZHDmHi3t6WKJI5dggr8jyKqWvTbz/c+ry8gNt5YbwC9+snP9+SWhwxHsrNoc/KJ9Iiu6TAsPc3Ur5XHrcXp6A2ig+YdKzGIJBDAstLN4US59PE4fRZTRwzCQai4/k8/K9DvxPQAaf/XuwLLNTE9qpyVHJrfxDwncr8CqF+iZ2JRRFAk/3dLagPW859GQE9Qxy6F1P4O12NonJ9KRUH1lWhjuD1fnx4feyWX0udRRg6X848aJ2a5lVwnzqtbxtgjnwPFFZWxfBLj8VWo4o1/6JR10yUqG145VP8NMmQ+U5pn5Ie+l6l1O1wcf7uNThBqysHm9GT5pcl1m2ncAh5O2n9hAFgSBIbmilUmoq3MFE1Og4J4+oBRG4+KjMEpeSa39NlDAg1KOJzzeXcvy59DOriYKyKJnGFcOSaN86ayCrBjRUJy4DNiOYH0U/DTk2efA/t1fFOy/sdBRM9GIKmEDTX/QC1r1Hr0K9G2VQKXUtgV7Mcz/rAT8SmWt3N41ZXaBA=="
	end

end
