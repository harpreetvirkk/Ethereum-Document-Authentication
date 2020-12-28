pragma solidity >=0.4.16 <0.7.0;
contract DocumentVerification {
    string[] username;
    string[] hash;
    // Input Format : username, 32byte sha256 hash of document starting with 0x
    function set(string memory _username, string memory _hash) public {
        username.push(_username);
        hash.push(_hash);
    }
    
    function slice(uint start, uint end, string memory h) internal pure returns (string memory) {
        bytes memory temp = new bytes((end-start)+1);
        for(uint i=0;i<=end-start;i++){
            temp[i] = bytes(h)[i+start];
        }
        return string(temp);    
    }
    
    function get(string memory _u, string memory _h) public view returns (bool) {
        
        for (uint i = 0; i < username.length; i++){
            if (  keccak256(bytes(_u)) == keccak256(bytes(username[i])) ){
                string memory first_half = slice(0, 31, (hash[i]));
                string memory end_half = slice(32, 63, (hash[i]));
                
                if ((keccak256(bytes(_h)) == keccak256(bytes(hash[i]))) || (keccak256(bytes(_h)) == keccak256(bytes(first_half))) || (keccak256(bytes(_h)) == keccak256(bytes(end_half)))){
                    return true;
                }
                
            } 
        }
        return false;
    }
}

// Sample Inputs
// username, <sha256hash>
// hsv,10d8311d6ec4dd9f6a5c2fc8b181804e91a44f8f6b4efec948ee0f123c1feca5
// lms,10d8311d6ec4dd9f6a58b181804e91a44f8f6b4efec948ee0f1888823c1feca4
// hah,20d8311d6ec4dd9f6a58b181804e91a44f8f6b4efec948ee0f1888823c1fec00

//To Check:

// hsv,10d8311d6ec4dd9f6a5c2fc8b181804e // first half
// hsv,91a44f8f6b4efec948ee0f123c1feca5 // second half
// lms,10d8311d6ec4dd9f6a58b181804e91a4 // first half
// lms,4f8f6b4efec948ee0f1888823c1feca4 // second half
// hah,20d8311d6ec4dd9f6a58b181804e91a4 // first half
// hah,4f8f6b4efec948ee0f1888823c1fec00 // second half

//Outputs - Boolean
//True if document hash and username is present
