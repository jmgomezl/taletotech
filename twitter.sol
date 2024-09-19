// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TwitterContract {
    
    struct Tweet {
        uint id;
        address user;
        string content;
        uint timestamp; // This will be used to sort the tweets
    }

    Tweet[] public tweets;
    uint public nextId;

    // Add a new tweet
    function addTweet(string memory content) public {
        tweets.push(Tweet(nextId, msg.sender, content, block.timestamp));
        nextId++;
    }

    // Function to return tweets in ascending or descending order by timestamp
    function getSortedTweets(bool ascending) public view returns (Tweet[] memory) {
        Tweet[] memory sortedTweets = tweets;
        
        for (uint i = 0; i < sortedTweets.length; i++) {
            for (uint j = i + 1; j < sortedTweets.length; j++) {
                if (ascending) {
                    if (sortedTweets[i].timestamp > sortedTweets[j].timestamp) {
                        Tweet memory temp = sortedTweets[i];
                        sortedTweets[i] = sortedTweets[j];
                        sortedTweets[j] = temp;
                    }
                } else {
                    if (sortedTweets[i].timestamp < sortedTweets[j].timestamp) {
                        Tweet memory temp = sortedTweets[i];
                        sortedTweets[i] = sortedTweets[j];
                        sortedTweets[j] = temp;
                    }
                }
            }
        }
        return sortedTweets;
    }
}
