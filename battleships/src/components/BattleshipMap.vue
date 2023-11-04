<template>
  <div class="game-container">
    <div class="game-controls">

      <div class="grid-map">
        <div class="grid">
          <div
              v-for="(cell, index) in cells"
              :key="index"
              :class="calculateCellClass(cell)"
              :data-row="getRow(index)"
              :data-col="getCol(index)"
              @click="clickCell($event, cell)"
              @mouseenter="hoverCell($event, cell)"
              @mouseleave="clearHover($event, cell)"
          ></div>
        </div>
      </div>

      <div class="user-controls">
        <div class="control-elements">

          <h4>Battle Command</h4>
          <el-radio-group v-model="userMode">
            <el-radio-button label="shoot">Shoot!</el-radio-button>
            <el-radio-button label="place">Place a ship</el-radio-button>
          </el-radio-group>


          <div class="place-controls" v-if="userMode === 'place'">
            <p>Choose ship orientation:</p>
            <el-radio-group v-model="shipOrientation">
              <el-radio-button label="horizontal">Horizontal</el-radio-button>
              <el-radio-button label="vertical">Vertical</el-radio-button>
            </el-radio-group>
          </div>
        </div>

        <div class="game-log">
          <message-log/>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import bannerImg from '@/assets/banner.png';
import {useMessageStore} from "@/store/messageStore.js";
import MessageLog from "@/components/MessageLog.vue";
import {useContractStore} from "@/store/contractStore.js";
import {useEventStore} from "@/store/eventStore.js"; // Adjust the path if necessary

const GRID_SIZE = 20;
const SHIP_LENGTH = 3;
const NEUTRAL = 0;
const HOVER_SHOOT = 1;
const HOVER_PLACE = 2;
const SHIP = 3;
const SHOT = 4;

export default {
  name: 'BattleshipMap',
  components: {MessageLog},
  setup() {
    return { bannerImg };
  },
  async mounted() {
    const eventStore = useEventStore();
    await eventStore.fetchTransactions();
  },
  data() {
    const cells = [];
    for (let i = 0; i < GRID_SIZE * GRID_SIZE; i++) {
      cells.push({
        row: this.getRow(i),
        col: this.getCol(i),
        state: NEUTRAL,
      });
    }
    return {
      cells,
      gameLog: [],
      userMode: 'shoot', // default mode
      shipOrientation: 'horizontal', // default orientation
    };
  },
  methods: {
    getRow(index) {
      return Math.floor(index / GRID_SIZE);
    },
    getCol(index) {
      return index % GRID_SIZE;
    },
    getCell(row, col) {
      let cellIdx = (row * GRID_SIZE) + col;
      const cell = this.cells[cellIdx];
      return cell;
    },
    calculateCellClass(cell) {
      const classes = ['cell'];
      if (cell.state === HOVER_SHOOT) {
        classes.push('highlight');
        classes.push('shoot');
      } else if (cell.state === HOVER_PLACE) {
        classes.push('highlight');
        classes.push('place');
      } else if (cell.state === SHIP) {
        classes.push('ship');
      } else if (cell.state === SHOT) {
        classes.push('shot');
      }
      return classes;
    },
    async clickCell(event, cell) {
      const messageLogStore = useMessageStore();
      const contractStore = useContractStore();

      if (this.userMode === 'shoot') {
        messageLogStore.addMessage(`Shoot at - Row: ${cell.row} Column ${cell.col}`);
        await contractStore.shoot(cell.row, cell.col);
        cell.state = SHOT;
      } else if (this.userMode === 'place') {
        messageLogStore.addMessage(`Added Boat at - Row: ${cell.row} Column ${cell.col}`);
        await contractStore.placeShip(cell.row, cell.col, this.shipOrientation);
        cell.state = SHIP;
        if (this.shipOrientation === 'horizontal') {
          for (let i = cell.col + 1; i < cell.col + SHIP_LENGTH; i++) {
            this.getCell(cell.row, i).state = SHIP;
          }
        } else {
          for (let i = cell.row + 1; i < cell.row + SHIP_LENGTH; i++) {
            this.getCell(i, cell.col).state = SHIP;
          }
        }
      }

      const logMsg = `${userAction} at: Row ${cell.row}, Column ${cell.col}`;
      messageLogStore.addMessage(logMsg);

    },
    hoverCell(event, cell) {
      const affectedCells = [];

      if (cell.state === SHOT || cell.state === SHIP
      ) {
        // don't allow hover on cells that have already been shot or have a ship, they're not valid
        return;
      }
      if (this.userMode === 'shoot') {
        cell.state = HOVER_SHOOT;
      } else if (this.userMode === 'place') {
        if (this.shipOrientation === 'horizontal') {
          if (cell.col > GRID_SIZE - SHIP_LENGTH) {
            // don't allow hover on cells that would go off the grid
            return;
          }
          cell.state = HOVER_PLACE;
          for (let i = cell.col + 1; i < cell.col + SHIP_LENGTH; i++) {
            // add the hover state to the cells that the ship would occupy
            this.getCell(cell.row, i).state = HOVER_PLACE;
          }
        } else {
          if (cell.row > GRID_SIZE - SHIP_LENGTH) {
            // don't allow hover on cells that would go off the grid
            return;
          }
          cell.state = HOVER_PLACE;
          for (let i = cell.row + 1; i < cell.row + SHIP_LENGTH; i++) {
            // add the hover state to the cells that the ship would occupy
            this.getCell(i, cell.col).state = HOVER_PLACE;
          }
        }
      }
    },
    clearHover(event, cell) {
      for (let i = 0; i < this.cells.length; i++) {
        // clear any hovers
        if (this.cells[i].state === HOVER_SHOOT || this.cells[i].state === HOVER_PLACE) {
          this.cells[i].state = NEUTRAL;
        }
      }
    },
  },
};
</script>

<style scoped>
.game-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  max-height: 100%;
  max-width: 100%;
  padding: 1rem;
}

.game-controls {
  display: flex;
  flex-direction: row;
  gap: 8px;
}

.user-controls {
  width: 100%;
  border-radius: 6px;
  border: 1px solid darkslategrey;
  background-color: slategray;
  padding: 1rem;
  max-height: 100%;
  display: flex;
flex-direction: column;
  gap: 8px;
  justify-content: space-between;
}

.grid-map {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  margin: 0 auto; /* Center the grid map horizontally */
}

.grid {
  display: grid;
  grid-template-columns: repeat(20, 1fr); /* Creates a 20x20 grid */
  grid-gap: 0;
  width: 50rem;
  height: 50rem;
}

.cell {
  width: 100%; /* Each cell takes up 100% of the column width */
  padding-bottom: 20%; /* Padding to maintain aspect ratio */
  background-color: #eee; /* Default cell background color */
  border: 1px solid #ccc; /* Cell border */
  box-sizing: border-box;
  cursor: pointer
  /*transition: background-color 0.3s; /* Smooth transition for background color */
}

.cell.highlight.shoot {
  background-color: red; /* Cell background color on hover */
}
.cell.highlight.place {
  background-color: darkslategrey; /* Cell background color on hover */
}
.cell.ship {
  background-color: darkolivegreen; /* Cell background color on hover */
}
.cell.shot {
  background-color: darkred; /* Cell background color on hover */
}
</style>
