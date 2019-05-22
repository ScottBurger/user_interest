# user_interest
Data and source code for calculating user interest decay rates

By taking in data in the form of:
Game, Date_of_Interest
Game1, 5/21/19
Game2, 5/22/19
Game1, 5/22/19
...

We can see how interest in certain games decay over time, given some sort of decay function.
Each day of interest generates 1 point, and each day without interest decays by 5%.

An example walkthrough of this script can be found on my blog: https://svburger.com/2019/01/06/how-interested-in-this-thing-am-i-really/
