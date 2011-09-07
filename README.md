
Exchanges are central to the growth of Bitcoin. 

An exchange can be broken into two parts.

 * The collection and distribution of bid/ask offers

 * Escrow service 

There are advantages to breaking up this functionality into seperate
services because they have very different properties. This project focuses
on the bid/ask offer database. See https://github.com/donpdonp/smallest-escrow
for an escrow service.

A traditional exchange with a central offers database allows for consistency
at the cost of a single point of failure and a communication bottleneck. An
alternative is a distributed database of offers. A participant with a history
of valuable offers would be a very popular network participant and traffic would 
increase at their location. It eliminates the arms-race of getting closer (network-wise)
to the centralized exchange at the expense of network delay.

# Roccobid
Roccobid is a ruby/GTK desktop app to listen and publish bid/ask offers to a telehash channel.

