+++
categories = ["programming", "ruby", "technical notes", "technical", "Import 2023-12-01 02:15"]
date = 2018-10-15T07:11:33Z
description = ""
draft = false
slug = "each-vs-map-vs-select"
summary = "I must admit, since I've began programming in Ruby, if you were to track stats on the iterator I use the most, embarrassingly it would be each. "
tags = ["programming", "ruby", "technical notes", "technical", "Import 2023-12-01 02:15"]
title = "each vs map vs select vs find"

+++


I must admit, since I've began programming in Ruby, if you were to track stats on the iterator I use the most, embarrassingly it would be each. I used each for everything. For some reason I believed it was efficient and if I needed to return new values, shoveling into a new array would suffice. So I thought. However, recently I've seen the error of my ways and have become familiar with Ruby's iterators in order to make rational decisions regarding which iterator or enumerable to use.


each



Why would you not want to use each?


As I was told recently, "...each is just for doing work on something." each does no transformation whatsoever. It only returns every element in which it is being iterated over. For example, let's take a look at the below code:

```ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9].each do |num|
    num += num
end
```



In the above example, we've an array that contains numbers 1 to 9 that are being iterated via the each method. Each element (number) in the array will be passed to the block. In this example, we want to take a number and increment by that number. But what we want and assume are two different things.

Here's a visual:

```ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9].each do |1|
    1 += 1
....

[1, 2, 3, 4, 5, 6, 7, 8, 9].each do |2|
    2 += 2
....

[1, 2, 3, 4, 5, 6, 7, 8, 9].each do |3|
    3 += 3
....
```




etcetera, etcetera, etcetera...

We would iterate over the whole array until we've reached the end.

Okay, nice. But what would you expect the return value to be?

If you say the return value will equal:

```ruby
=> [2, 4, 6, 8, 10, 12, 14, 16, 18]
``` 



then I am sorry, you are wrong. And that's okay. Because I too did not realize this in the beginning. The method defines itself. It and all other Ruby iterators are appropriately named. Once you realize this it makes things easier.

Regardless of what is in the block, whether we are subtracting, dividing, multiplying every element in the array, each will always return the original array, without transformation! Here's a silly example:

```ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9].each do |num|
    "poop"
end
``` 



This will return:

```ruby
=> [1, 2, 3, 4, 5, 6, 7, 8, 9]
```



Try it yourself!

Okay this is great, but isn't this method mostly useless for certain tasks unless I save all values into a new array?

each is not useless, it exists with reason and when necessary can be used. It accepts the things (all the things) it cannot change but it is you, the developer who must have the wisdom to know when to use it.



So what if I want a new array without using each and pushing into a second array?

Well, that's why map exists!


map


map is for transformation. It returns a new array of transformed elements.

Here's an example:

```ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9].map do |num|
    num.even?
end
```



We can confidently expect the return value to be:

```ruby
=> [false, true, false, true, false, true, false, true, false]
```





Here's another one:

```ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9].collect do |num|
    "poop"
end
```



Notice here that I've used the method name collect. In Ruby, both map and collect are identical, there is no difference. You can use either but if you would like to type less I would recommend map. However, I find that being aware of the existence of collect helps to define the iterator easily. Personally, unlike each, map iterator doesn't define itself. But I find it easier with collect which does define itself. I like to imagine that if each element were an egg, the Easter Bunny would go and collect them, placing the results of the block in a basket. Maybe it's too dramatic but I find it helpful.

In the above example, our return value would be:

```ruby
=> ["poop", "poop", "poop", "poop", "poop", "poop", "poop", "poop", "poop"]
``` 



You probably expected either the string "poop" to be ignored, printed once or the array returned. However, this is not the case. Here, we have transformation, a new array. The string "poop" is being compared with each element in the array and returned until we've reached the end of the array.

```ruby
1 => "poop", 2 => "poop", 3 => "poop", etc.
```

Now that we've covered the each and map iterators there are two important methods to cover, they are enumerables.

I like to think of these iterators as "picky iterators"[1] as they return based on whichever condition is written in the block.



select


The select enumerable, selects (see I told you these methods were appropriately named) elements from an array based on a condition and returns them.


Here's an example:

```ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9].select do |num|
    num.even?
end
```



The code above will literally select only even numbers in the array.


Therefore, the return value will be:

```ruby
=> [2, 4, 6, 8]
```



 

No surprises right?


 

Here's another:

```ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].select do |num|
    7
end
```



The return value will be:

```ruby
=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```



The block in this example was ignored because there was no condition.



find


Our last enumerable finds or returns only the first element per our condition.


Here's an example:

```ruby
[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].find do |num|
    num.even?
end
``` 



The return value will only be the first element of the array that is even.


Therefore, its return value will be:

```ruby
=> 2
``` 



And that's it!


I like to think of find as a dog who plays fetch.




![Dog playing fetch GIF](/images/dog_fethc.gif)


 

These are some of Ruby's iterators and enumerables, it is important to know when one must be used in order to return the expected output. There are also many other methods that do more. If you're curious, just read the docs.






 1. Technically select and find are not iterators unlike each and map which are. They are enumerators and provide many methods to search based on conditions.
    
    https://ruby-doc.org/core-2.5.1/Enumerable.html ↩︎
    

