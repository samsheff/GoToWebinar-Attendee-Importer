# GoToWebinar Atttendee importer, Saves to MongoDB

require 'mongo_mapper'
require './GoToWebinar-Ruby/lib/go_to_webinar.rb'
require './conf/attendee.rb'


MongoMapper.setup({'default' => {'uri' => ARGV[0]}}, 'default')

oauth_access_token = ARGV[1]
organizer_key = ARGV[2]

#Check for OAuth Token and Organizer Key
if (oauth_access_token == nil or organizer_key == nil)
    puts "Missing either an OAuth Token or Organizer Key"
    exit
end

#Define Counter
i = 0

#Define Dates
time = Time.new
start = (time - 10.years).strftime("%Y-%m-%dT%H:%M:%S")
finish = time.strftime("%Y-%m-%dT%H:%M:%S")

#Create G2W Class Object and get all webinars within 10 years. Then add them to the Database
g2w = GoToWebinar::Client.new(oauth_access_token, organizer_key)
webinars = g2w.get_historical_webinars({:toTime => start, :fromTime => finish})
puts "Importing Webinars"
for w in webinars
    attendees = g2w.get_attendees_for_all_webinar_sessions(w['webinarKey'])
    for a in attendees
        entry = Attendee.new
        
        entry.firstName = a['firstName']
        entry.lastName = a['lastName']
        entry.email = a['email']
        entry.timeAttended = a['attendanceTimeInSeconds'].to_i
        entry.webinar = w['webinarKey']
        entry.webinarsubject = w['subject']
        
        entry.save

        puts "Done: " + i.tio_s
        i += 1

    end
end

