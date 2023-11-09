// Delearn Homepg, with regestration, faq
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Clearn {
    address public owner;
    mapping(address => Home) homes; // Mapping of addresses to Home structs

    constructor() {
        owner = msg.sender;
    }

    struct Home {
        AboutData[] About_us;
        CourseData[] Course;
        CertData[] Cert;
        AdData[] Ad;
        FaqData[] Faq;

        // User registration
        string rname;
        bool isRegistered;
    }
    mapping(string=>Home) maphome;

    struct AboutData {
        string name;
        string obj;
        string princ;
    }

    struct CourseData {
        string title;
        string link;
    }

    struct CertData {
        string ctitle;
        string clink;
    }

    struct AdData {
        string atitle;
        string alink;
    }

    struct FaqData {
        string quest;
        string ans;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function register(string memory _name) public {
        Home storage h = homes[msg.sender];
        h.rname = _name;
        h.isRegistered = true;
    }

    function addAbout(string memory name, string memory obj, string memory princ) public onlyOwner {
        Home storage h = homes[msg.sender];
        h.About_us.push(AboutData(name, obj, princ));
    }

    function addCources(string memory title, string memory link) public onlyOwner {
        Home storage h = homes[msg.sender];
        h.Course.push(CourseData(title, link));
    }

    function addCert(string memory ctitle, string memory clink) public onlyOwner {
        Home storage h = homes[msg.sender];
        h.Cert.push(CertData(ctitle, clink));
    }

    function addAd(string memory atitle, string memory alink) public onlyOwner {
        Home storage h = homes[msg.sender];
        h.Ad.push(AdData(atitle, alink));
    }
    
    function addFaq(string memory quest, string memory ans) public onlyOwner {
        Home storage h = homes[msg.sender];
        h.Faq.push(FaqData(quest, ans));
    }

    function viewAbout() public view returns (AboutData[] memory) {
        Home storage h = homes[msg.sender];
        return h.About_us;
    }

    function viewCourse() public view returns (CourseData[] memory) {
        Home storage h = homes[msg.sender];
        require(h.isRegistered, "User is not registered");
        return h.Course;
    }

    function viewCertificates() public view returns (CertData[] memory) {
        Home storage h = homes[msg.sender];
        require(h.isRegistered, "User is not registered");
        return h.Cert;
    }

    function viewAdvertisements() public view returns (AdData[] memory) {
        Home storage h = homes[msg.sender];
        return h.Ad;
    }

    function viewFAQs() public view returns (FaqData[] memory) {
        Home storage h = homes[msg.sender];
        return h.Faq;
    }

    function askQuestion(string memory keywords) public view returns (string[] memory, string[] memory) {
    Home storage h = homes[msg.sender];
    
    string[] memory matchedQuestions;
    string[] memory matchedAnswers;

    for (uint256 i = 0; i < h.Faq.length; i++) {
        if (containsKeywords(h.Faq[i].quest, keywords)) {
            matchedQuestions = append(matchedQuestions, h.Faq[i].quest);
            matchedAnswers = append(matchedAnswers, h.Faq[i].ans);
        }
    }

    if (matchedQuestions.length > 0) {
        return (matchedQuestions, matchedAnswers);
    } else {
        return (new string[](0), new string[](0)); // Empty arrays indicate no matches
    }
}

function containsKeywords(string memory haystack, string memory keywords) internal pure returns (bool) {
    bytes memory haystackBytes = bytes(haystack);
    bytes memory keywordsBytes = bytes(keywords);

    for (uint256 i = 0; i < haystackBytes.length - keywordsBytes.length + 1; i++) {
        bool isMatch = true;
        for (uint256 j = 0; j < keywordsBytes.length; j++) {
            if (haystackBytes[i + j] != keywordsBytes[j]) {
                isMatch = false;
                break;
            }
        }
        if (isMatch) {
            return true;
        }
    }

    return false;
}

function append(string[] memory arr, string memory element) internal pure returns (string[] memory) {
    string[] memory newArr = new string[](arr.length + 1);
    for (uint256 i = 0; i < arr.length; i++) {
        newArr[i] = arr[i];
    }
    newArr[arr.length] = element;
    return newArr;
}
}
