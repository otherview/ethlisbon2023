// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Battleship {

    uint constant public GRID_SIZE = 20;
    uint constant public MAX_SHIPS_PER_PLAYER = 1;
    uint constant public SHIP_SIZE = 3;
    uint256 public shipIDCounter = 1; // start with 1 to know when it is empty or not.


    // TODO: Currently each ship is of size 3
    struct Ship {
        uint position;
        bool isVertical; // position is top of the boat if vertical and left if horizontal
        bool[3] hits;
        address owner;
        uint256 shipID;
    }

   struct Player {
        Ship[MAX_SHIPS_PER_PLAYER] ships;
        uint shipCount;
        bool isAlive;
    }

    mapping(address => Player) public players;

    // position -> ship id
    mapping(uint => uint256) public world;

    // shipId -> ship structure
    mapping(uint256 => Ship) public ships;

    // Event to represent invalid placement
    event InvalidShipPlacement(address player, uint position);

    // Event that is emitted when a player joins the game
    event PlayerJoined(address player);

    // Event that is emitted when a player shoots
    event PlayerShoots(address player, uint position, bool hit);

    // Event that is emitted when a player places a new boat
    event PlayerAddsABoat(address player, uint position, bool isVertical);

    // Event that is emitted when a ship is sunk
    event ShipSunk(address player);

    // Player joins the game
    function joinGame(uint position, bool isVertical) public {
        // TODO: Check if player is already in the game

        // check if placement is valid
        require(isValidPlacement(position, isVertical), "Invalid ship position");
       
        // create and implement new shipID
        uint256 newShipID = shipIDCounter;
        shipIDCounter = shipIDCounter + 1;

        // create a new ship instance
        Ship memory newShip = Ship({
            position: position,
            isVertical: isVertical,
            hits:  [false, false, false],
            owner: msg.sender,
            shipID : newShipID
        });

        // place new ship in a mapping
        ships[shipIDCounter] = newShip;

        // place a ship in the world
        if (isVertical) {
            world[position] = newShipID;
            world[position+GRID_SIZE] = newShipID;
            world[position+2*GRID_SIZE] = newShipID;
        } else {
            world[position] = newShipID;
            world[position+1] = newShipID;
            world[position+2] = newShipID;
        }

        emit PlayerAddsABoat(msg.sender, position, isVertical);

    }

    // Check if the placement is valid (we need to check if whole ship is in a grid and 
    function isValidPlacement(uint position, bool isVertical) public view returns (bool) {
        // TODO: add ship size if we want different sizes of ships
        // check if the whole ship is inside the grid

        // it is vertical and it is outside of the grid -> return false
        if(isVertical && position+(SHIP_SIZE-1)*GRID_SIZE > GRID_SIZE*GRID_SIZE) {
            return false;
        }

        // it is horizontal and it is outside of the frid -> return false
        if (!isVertical && position+(SHIP_SIZE-1) > GRID_SIZE*GRID_SIZE) {
            return false;
        }

        // check all the positions if there is a ship already there
        if (isVertical) {
            for (uint i = 0; i < SHIP_SIZE-1; i++) {
                if (world[position+i*GRID_SIZE] != 0) {
                    return false;
                }
            }
        }

         if (!isVertical) {
            for (uint i = 0; i < SHIP_SIZE-1; i++) {
                if (world[position+i] != 0) {
                    return false;
                }
            }
        }

        return true;
    }

    function isShipDestroyed(Ship memory ship) public pure returns (bool) {
        for (uint i = 0; i < ship.hits.length; i++) {
            if (!ship.hits[i]) {
                return false;
            }
        }
        return true;
    }

    function Shoot(uint position) public payable returns (bool) {
        // check if there is a ship at desired position
        if (world[position] != 0) {
            // we hit a ship
            emit PlayerShoots(msg.sender, position, true);
            ShipHit(ships[world[position]], position);
            return true;
            
        } else {
            emit PlayerShoots(msg.sender, position, false);
        }

        return false;

    }

    function ShipHit(Ship memory ship, uint position) public returns (bool) {
        // x x x x x
        // x o x x x
        // x o x x x
        // x o x x x
        // x x x x x

        // ship position = 6
        // hit position = 16
        // world size = 5
        // we want to get index = 2

        // figure out where the ship was hit and change the hit array accordingly
        uint hit_index = 0;
        if (ship.isVertical) {
            hit_index = (position - ship.position) / GRID_SIZE;
        } else {
            hit_index = position - ship.position;
        }

        ship.hits[hit_index] = true;

        if(isShipDestroyed(ship)) {
            emit ShipSunk(ship.owner);
            return true;
        }

        return false;
    }
    

    // Utility function to check if a player is still in the game
    function isPlayerAlive(address player) public view returns (bool) {
        
    }

    // Utility function to get the number of active players
    function getActivePlayerCount() public view returns (uint) {
    }

    // Reset the game (this could be restricted to the owner only)
    function resetGame() public {
       
    }
}
