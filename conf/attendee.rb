#Model Class for Webinar Attendees
class Attendee
    include MongoMapper::Document

    key :registrantKey, String
    key :firstName, String
    key :lastName, String
    key :email, String
    key :webinar, String
    key :webinarsubject, String
    key :timeAttended, Integer

end