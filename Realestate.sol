// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstate {
    struct Owner{
        bool isgovt;
        string name;
        address myaddress;
        uint256 Property_count;
    }
    struct Property {
        uint id;
        string Property_name;
        uint price;
        string description;
        address owner;
        string location;
        bool issale;
    }
    Property[] public properties;
    mapping (address => Owner) public Owners;
    mapping (uint => string) public  links;
    constructor(string memory name)
    {
        Owners[msg.sender]=Owner(true,name,msg.sender,0);
    }
    function registerUser(string memory _name) public {
        Owners[msg.sender] = Owner(false, _name, msg.sender, 0);
    }

    function isRegistered(address _address) external view returns (bool) {
        return Owners[_address].myaddress != address(0);
    }

    //property Register event
    event PropertyRegistered(uint indexed id,string Property_name, uint price, address indexed owner, string location);
    //Buy Event
    event PropertyBought(uint indexed id, uint price, address indexed newOwner, string location,bool issale);
    //register method which collect data for that product
    function registerProperty(string memory Property_name,string memory description, uint _price, string memory _location)  payable  public  returns (uint) {
        require(Owners[msg.sender].isgovt,"Govt only can");

        Owners[msg.sender].Property_count++;
        uint propertyId = properties.length;
        properties.push(Property(propertyId,Property_name,_price,description, msg.sender, _location,true));
        emit PropertyRegistered(propertyId,Property_name,_price, msg.sender, _location);
        return propertyId;
    }
    // method for buy propertyid is required
    function buyProperty(uint _propertyId,bool val) public payable {
        require(_propertyId < properties.length, "Invalid property ID");
        Property storage property = properties[_propertyId];
        require(msg.sender != property.owner, "You are already the owner of this property");
        address payable previousOwner = payable(property.owner);
        previousOwner.transfer(property.price);
        Owners[property.owner].Property_count--;
        property.owner = msg.sender;
        Owners[msg.sender].Property_count++;
        emit PropertyBought(_propertyId, property.price, msg.sender, property.location,val);
    }
    function serlink(uint id,string memory add) public 
    {
        links[id]=add;
    }
    function fetchlink(uint id) public  view  returns  (string memory)
    {
        return links[id];
    }
    // Function to fetch data of all properties
    function fetchData() public view returns (Property[] memory) {
        return properties;
    }
    function fetchuser(address add) public  view  returns (Owner memory)
    {
        return Owners[add];
    }
    function fetchprop(uint id) public  view  returns (Property memory)
    {
        return properties[id];
    }
    function verify(uint id) view   public returns (address)
    {
        uint length = properties.length;
        if(id < length)
            {
                Property storage property = properties[id];
                return Owners[property.owner].myaddress;
            }
        return address(0);
    }
}
