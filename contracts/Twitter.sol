// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Twitter {
    address public owner;
    uint16 public maxTweetLength = 280;

    uint256 public tweetCount; 

    event TweetCreated(uint256 indexed id, address indexed author, string content, uint256 timestamp);
    event TweetLiked(uint256 indexed id, address indexed liker, uint256 likeCount);
    event TweetUnliked(uint256 indexed id, address indexed unliker, uint256 likeCount);
    event MaxTweetLengthChanged(uint16 oldLength, uint16 indexed newLength);

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(uint256 => Tweet) public tweetsById;
    mapping(address => uint256[]) public authorTweets;
    mapping(uint256 => mapping(address => bool)) public liked;

    modifier onlyOwner() {
        require(msg.sender == owner, "OWNER can only do this!");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function changeTweetLength(uint16 _newLength) external onlyOwner {
        uint16 old = maxTweetLength;
        maxTweetLength = _newLength;
        emit MaxTweetLengthChanged(old, _newLength);
    }

    function createNewTweet(string memory _content) external {
        require(bytes(_content).length <= maxTweetLength, "reduce the tweet length");

        uint256 id = tweetCount;
        tweetsById[id] = Tweet({
            id: id,
            author: msg.sender,
            content: _content,
            timestamp: block.timestamp,
            likes: 0
        });

        authorTweets[msg.sender].push(id);

        tweetCount += 1;

        emit TweetCreated(id, msg.sender, _content, block.timestamp);
    }

    function likeTweet(uint256 _id) external {
        require(_id < tweetCount, "Tweet does not exist");
        require(!liked[_id][msg.sender], "Already liked");

        liked[_id][msg.sender] = true;
        tweetsById[_id].likes += 1;

        emit TweetLiked(_id, msg.sender, tweetsById[_id].likes);
    }

    function unLikeTweet(uint256 _id) external {
        require(_id < tweetCount, "Tweet does not exist");
        require(liked[_id][msg.sender], "Not liked yet");

        liked[_id][msg.sender] = false;
        tweetsById[_id].likes -= 1;

        emit TweetUnliked(_id, msg.sender, tweetsById[_id].likes);
    }

    function getAuthorTweetIds(address _author) external view returns (uint256[] memory) {
        return authorTweets[_author];
    }
}
