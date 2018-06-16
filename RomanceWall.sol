pragma solidity ^0.4.19;

contract RomanceWall{
    
    // new instance of IDCard
    IDCard idc = IDCard(0x692a70d2e424a56d2c6c27aa97d1a86395877b3a);

    // structure of the profession
    struct profession {

        // the user ID
        bytes24 sender;
        // user address
        address adr;
        // profession time
        uint time;
        // the content of profession
        string content;
        // the price paid
        uint payment;
        // theme color for IDCard users ONLY
        uint color;
        // level of the user
        uint level;
    }
    
    //contract owner & init vars
    address public owner;
    
    constructor() public payable{
        
        owner = msg.sender;
        
    }

    // user payment
    uint public amount;
    
    // safe withdraw
    function withdraw() public payable{
        
        require(owner == msg.sender);
        
        uint temp_amount = amount;
        amount = 0;
        
        msg.sender.transfer(temp_amount);
    }
    
    // all the professions on the wall
    profession[] public profession_list;

    // count the total number of professions on the wall
    uint public counter = 0;
    
    // length limit
    uint public limit = 100;

    // send the profession
    function send_profession(string content, uint color) public payable{
        
        require(bytes(content).length<=limit);
        // user info regardless registration 
        bytes24 name = idc.IDs(msg.sender);
        var (id,addr,profile,about,prestige,level,active,used,index) = idc.info(name);
        if (active == true){
            
            // add the new profession to the wall
            profession_list.push(
                
                // create a new profession
                profession({
            
                adr : msg.sender,
                sender : name,
                content : content,
                payment : msg.value,
                time : now,
                level : level,
                color : color
            
                })
            
            );
            
            counter += 1;
            
        // is NOT a registered IDCard user
        }else{
    
            // add the new profession to the wall
            profession_list.push(
                
                // create a new profession
                profession({
            
                // use default name, level, and color
                adr : msg.sender,
                sender : name,
                content : content,
                payment : msg.value,
                time : now,
                level : level,
                color : 0
            
                })
            
            );
            
            counter += 1;
            
        }
        
        amount += msg.value;

    }
    
    function set_limit(uint _limit) public {
        require(owner == msg.sender);
        limit = _limit;
    }

}

