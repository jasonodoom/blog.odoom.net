+++
categories = ["ruby", "programming", "projects", "humor", "Import 2023-12-01 02:15"]
date = 2018-10-22T08:20:46Z
description = ""
draft = false
slug = "activerecord-models-and-grammar"
summary = "My weekend project consisted of me creating something with ActiveRecord. That something took me a a bit of time to figure out. I knew my time was limited so I did not want to pursue a gargantuan task. From experience, I came to the conclusion that a game would not be a good option. However,"
tags = ["ruby", "programming", "projects", "humor", "Import 2023-12-01 02:15"]
title = "ActiveRecord,  Models and Grammar"

+++


My weekend project consisted of me creating something with ActiveRecord.[1] That something took me a a bit of time to figure out. I knew my time was limited so I did not want to pursue a gargantuan task. From experience, I came to the conclusion that a game would not be a good option. However, this is what I decided upon as at the time it seemed like a very basic idea. But I lacked sincerity. Eventually, I did create a "game", if one could even call it that.



There was no planning, no organization. Initially....


I knew I wanted to put my skills to use. But how? Program a Bot in Ruby? Create a Ruby Gem (currently looking into this)? Since I would soon be utilizing ActiveRecord, I decided that it would make sense to spend additional time with it. In a non-linear series of events I found myself Friday afternoon noting the model class I would create, what I would like to think of as "the philosophy." At times I find this overwhelming not because I think it's difficult but I tend to overthink the relationships.




![Dr. Strange GIF](/images/drstrange.gif)


Especially in this instance where we've a Post Office, Delivery Person and Recipient. The language also didn't help. I will agree a post office is a post office (or is it postal office?). And a recipient could be a receiver but recipient is more formal. Yet, what really bothered me was what to call the delivery person. Delivery man? No, sexist. Delivery woman? No, sexist. Deliverer? Informal and with an arguably religious connotation. With some help, it was agreed that delivery person was the better choice.


Now that this issue had been resolved the next problem was the relationships.[2]


This model would be a has many relationship. That was obvious. This would allow me to build a one-to-many connection with Delivery Person being our join table. So a post office then has many delivery people, it also has many recipients through a delivery person (join). Great, got it. A delivery person would then belong to a post office and a delivery person would also belong to a recipient.


And this is when I had to prevent myself from overthinking or questioning this relationship. Because this is not politics. The notion that in this model class a delivery person belongs to a post office and a recipient philosophically is not the same as saying a dog belongs to an owner. These relationships aren't meant for such scrutiny. Yet, at times I find these ideas difficult to avoid. But I pushed forward.


There is also a similar relationship for the Recipient class where a recipient belongs to a delivery person (that's fair just not in the philosophical/moral sense). The recipient also belongs to a post office as the post office exists to deliver mail in which it would no longer if there were no recipients to deliver to. Fair. [3]


At long last, we had our three classes:


postoffice.rb

```ruby
class PostOffice < ActiveRecord::Base
  has_many :delivery_people
  has_many :recipients, through: :delivery_people
end
```



deliveryperson.rb

```ruby
class DeliveryPerson < ActiveRecord::Base
  belongs_to :post_office
  belongs_to :recipient
end
```



recipient.rb

```ruby
class Recipient < ActiveRecord::Base
 belongs_to :delivery_person
 belongs_to :post_office
end
```



And that's essentially all we need to do. Because ActiveRecord basically takes care of the basics so you don't have to! At that point you can begin writing code.


In the below example we've a Driver class which would be included with other models such as Passenger and Ride (join). This would be the "old way":

```ruby
class Driver

 @@all = Array.new

 attr_accessor :name, :distance

  def initialize(name)
    @name = name

   @@all << self
  end

  def passenger_names # Returns an array of all Passengers' names a driver has driven.
     array_of_passengers = Array.new
    Passenger.all.each do |passenger|
        array_of_passengers << passenger.name
    end
    return array_of_passengers.uniq!
  end

  def self.all
    @@all
  end


  def self.mileage_cap(distance) # Takes an argument of a distance (float) and returns an array of all Drivers who have driven over the mileage
    overLimitDrivers = Array.new
    Ride.all.each do |ride|
      if ride.distance > distance.to_f
        binding.pry
        overLimitDrivers << ride.driver.name
      end
    end
    overLimitDrivers
  end

end
```




In the example above there are two methods that have not been struck through. This is optional as you would still need to write methods to create, read, update or delete information. ActiveRecord is not magic. Though I would say you now have additional tools to make them shorter and efficient.



Grammar is important, but we set the rules


An issue I had when creating a migration via rake was grammar. And although I could have overwrote this particular naming convention[4] I descended into the rabbit hole of Ruby's inflections[5]. These rules are dogma and will never change,[6] regardless of your opinion on why Ruby's plural version of a word doesn't make sense.


However, I would admit that in this instance, I was at fault. I believed the plural of delivery person was delivery persons. However, it's actually delivery people. Duh.


![Confused child GIF](/images/confusedkid.gif)


I had assumed the inflector's default would be delivery persons since I've come acoss some inflections I did not agree with. But hey, at least Rails core knows to not inflect rice.[7]



A one person Hackathon


Once the issues were resolved I began writing the code for the ActiveRecord-PostOffice project[8] which is functional but needs refactoring. It's not ambitious and I attempted to keep it simple as much as possible. I only had one weekend.


The basis of the game is that you (the player) are a delivery person and must deliver mail to your recipients. It was good fun and has left me with knowledge, questions and ideas to improve my Ruby experience. Hopefully, I can perfect it or create something better. Only time will tell...






 1. https://guides.rubyonrails.org/active_record_basics.html ↩︎
    

 2. I've still not decided if it's better to enter models feigning ignorance by dismissing everything I think I know about relationships and associations to help aid in the process. ↩︎
    

 3. This concept is often complicating but asking questions such as, "Wait, but why?" help make it easier to comprehend. ↩︎
    

 4. https://stackoverflow.com/questions/1185035/how-do-i-override-rails-naming-conventions ↩︎
    

 5. https://api.rubyonrails.org/classes/ActiveSupport/Inflector.html ↩︎
    

 6. The Rails core team has stated patches for the inflections library will not be accepted in order to avoid breaking legacy applications which may be relying on errant inflections. ↩︎
    

 7. https://github.com/rails/rails/blob/master/activesupport/lib/active_support/inflector/inflections.rb ↩︎
    

 8. https://github.com/jasonodoom/ActiveRecord-PostOffice ↩︎
    





