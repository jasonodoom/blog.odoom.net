+++
categories = ["considerations", "pseudo-technical", "drones", "war", "developers", "morality", "philosophy", "untechnical", "Import 2023-12-01 02:15"]
date = 2018-11-13T09:43:24Z
description = ""
draft = false
slug = "an-api-to-kill"
summary = "This post is less about APIs and concerns the moral implications of current technologies. This post does not reflect any of my current beliefs. "
tags = ["considerations", "pseudo-technical", "drones", "war", "developers", "morality", "philosophy", "untechnical", "Import 2023-12-01 02:15"]
title = "An API to kill"

+++


Disclaimer: This is a fictitious post. That means it is not real. Yet.




Preface


This post is less about APIs and concerns the moral implications of current technologies. This post does not reflect any of my current beliefs.


With the advent of Artificial Intelligence (A.I.) in the mainstream there lies a plethora of moral and ethical concerns. And why not? If the genre of science fiction has taught us anything, when Man creates, he is doomed. There are many examples in Sci-Fi where the outcome is never perceived before creation. The scientist or main character usually creates to solve a problem that she or he thinks will benefit the greater good. However, what is usually disregarded is whether or not this creation will create new problems in the future. Ironically, this happens in the real world as well where we at times are focused on solving problems but fail to think beyond our solutions. Yet, one thing is certain, we should just learn how to solve problems without creating new ones.




![A Reaper Drone.](/images/MQ-9-Reaper-19-May-2017.jpg)


The use of an Unmanned aerial vehicle (UAV) beyond private sector and into personal or consumer use is alarming. Of course the Drones, as they are commonly referred to offered to consumers are incomparable to the advanced models used by military personnel. However, the sense that there is a "dark history" associated with these devices fails to reach buyers. Initially used for missions too "dull, dirty or dangerous" [1] they've found greater use elsewhere. It's a bit strange to think how this machine, regardless of a difference in function and size when compared to consumer models have been used in sometimes clandestine operations where a person or people are murdered. After all, a UAV was used to kill the terrorist Osama bin Laden in 2011.[2] So who can argue the cons when they've done so much good? And you can forget about civilian casualties. If they are able to kill terrorists then they are necessary. Not to mention if it were not for these machines we would not have exceptional aerial footage that have so greatly plagued the videos of our favorite YouTubers. Now all the masses have access to Drones, to do with whatever they choose.




![A Bar Chart displaying civilian casualties by Drone strike in Pakistan](/images/All-Totals-Dash29.jpg)


Have we forgotten so quickly the collateral murders these machines have committed? The next time you operate or watch a film that was recorded using a Drone, think of the dead.



What is API?


API is Application Programming Interface. It enables one to build applications using protocols and tools. Basically, APIs allow developers to interact or interface with an application by grabbing, adding and even sometimes modifying data. When you visit a dynamic website and search for a specific keyword you are interacting with an API via API calls.



Assassination via Curl


Consider a world where a developer has created a remote API to interact with these unmanned vehicles and feed them instructions regarding what steps to take via a payload[3]. Suddenly, programs will be created to assist in assasinations. Now envision such a concept married with the advent of A.I. and you've an autonomous device that can optionally take requests via API calls or do whatever it chooses to in compliance with the mission it was programmed to execute. Or not.







Because A.I. has the potential to be unpredictable if we are not careful[4].


The developers of the future will be the ones responsible for creating such tools to fuel the war machine. Envision the many technologies that will become available. Most especially one which was my intention for writing this post: an API. To kill.


Imagine an API call such as:


```bash
curl -i -L --user api:eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJtZXNzYWdlIjoiSldUIFJ1bGVzIS\ -X PUT -H "Content-Type: application/json" \ --data '{"instruction": "autonomous mode set on"}' \ target://eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2V4YW1wbGUuYXV0aDAuY29tLyIsImF1ZCI6Imh0d.gov/HBzOi8vYXBpLmV4YW1wbGUuY29tL2NhbGFuZGFyL3YxLyIsInN1YiI6InVzcl8xMjMiLCJpYXQiOjE0NTg3ODU3OTYsImV4cCI6MTQ1ODg3MjE5Nn0.CA7eaHjIHz5NxeIJoFK9krqaeZrPLwmMmgI_XiQiIkQ

```

![](/images/2001_a_space.gif)

![](/images/hal9000.gif)

I can only expect that in this scenario HTTPS would not be used, allowing the management or control over these vehicles to be handled over a newly created protocol. In the example above, I've just called it the target:// protocol. Use your imagination.



But what does this mean for the future?


That's the concern. The future of war will only become more sophisticated as time progresses. we are approaching these possiblities. [5] Morality is important because without it there would not be the universally accepted concepts of good and bad to judge our actions against. I can only highly recommend this post which details this principle further in relation to roles developers play in "building the future."


As developers, we must choose between good and evil. The work we do can either build nations or destroy them. It's easier said than done like most things. The number of zeroes on a check is tempting and is what drives most people. However, if you can live with the guilt your immoral decisions as a developer creates then continue.




![Alex and his droogs living carelessly.](/images/alexanddroogs.gif)



How to tell if something is immoral


Apply the categorical imperative:[6]


 * Ask, "Should this be universal law?"
 * Ask, "Is this good for me?"
 * Ask, "Is this good for others?"
 * Ask, "Is this good for the world?"


If the answer is "no", walk away.






 1. https://web.archive.org/web/20090724015052/http://www.airpower.maxwell.af.mil/airchronicles/apj/apj91/spr91/4spr91.htm ↩︎
    

 2. https://www.airspacemag.com/military-aviation/drone-staked-out-bin-ladens-neighborhood-180958482/ ↩︎
    

 3. https://en.wikipedia.org/wiki/Payload_(computing) ↩︎
    

 4. https://www.washingtonpost.com/news/innovations/wp/2018/04/06/elon-musks-nightmarish-warning-ai-could-become-an-immortal-dictator-from-which-we-would-never-escape/?noredirect=on&utm_term=.f6982b390253 ↩︎
    

 5. http://www.washingtonpost.com/wp-srv/special/national/drone-crashes/how-drones-work/?noredirect=on ↩︎
    

 6. https://en.wikipedia.org/wiki/Categorical_imperative ↩︎
    

