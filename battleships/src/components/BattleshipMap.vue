<template>
  <div class="game-container">
    <div class="game-controls">

      <div class="grid-map">
        <div class="grid" @click="clickCell($event)">
          <div
              v-for="(cell, index) in cells"
              :key="index"
              :class="`cell ${cell.state > 0 ? 'highlight' : ''}`"
              :data-row="getRow(index)"
              :data-col="getCol(index)"
              @mouseenter="hoverCell($event, cell)"
              @mouseleave="clearHover($event, cell)"
          ></div>
        </div>
      </div>

      <div class="user-controls">
        <h4>Command deck</h4>
        <input type="radio" id="shoot" value="shoot" v-model="userMode">
        <label for="shoot">Shoot!</label>

        <input type="radio" id="place" value="place" v-model="userMode">
        <label for="place">Place Ship</label>

        <div class="place-controls" v-if="userMode === 'place'">
          <p>Choose ship orientation:</p>
          <input type="radio" id="horizontal" value="horizontal" v-model="shipOrientation">
          <label for="horizontal">Horizontal</label>

          <input type="radio" id="vertical" value="vertical" v-model="shipOrientation">
          <label for="vertical">Vertical</label>
        </div>

<!--        <p>Selected Mode: {{ userMode }}{{ userMode === 'place' ? ` ${shipOrientation}` : "" }}</p>-->
      </div>
    </div>

    <div class="game-log">
      <h2>Game Log</h2>
        <message-log/>
    </div>
  </div>
</template>

<script>
import bannerImg from '@/assets/banner.png';
import {useMessageStore} from "@/store/messageStore.js";
import MessageLog from "@/components/MessageLog.vue";
import {useContractStore} from "@/store/contractStore.js"; // Adjust the path if necessary

const GRID_SIZE = 20;
const SHIP_LENGTH = 3;
const NEUTRAL = 0;
const HOVER_SHOOT = 1;
const HOVER_PLACE = 2;

export default {
  name: 'BattleshipMap',
  components: {MessageLog},
  setup() {
    return { bannerImg };
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
    clickCell(event) {
      const cell = event.target;
      if (cell.classList.contains('cell')) {
        const row = cell.dataset.row;
        const col = cell.dataset.col;

        const messageLogStore = useMessageStore();
        const contractStore = useContractStore();

        const userAction = this.userMode === 'shoot' ? 'Shoot' : `Place ship (${this.shipOrientation})`;
        const logMsg = `${userAction} at: Row ${row}, Column ${col}`;
        messageLogStore.addMessage(logMsg);
        contractStore.shoot(row, col);
      }
    },
    hoverCell(event, cell) {
      const messageLogStore = useMessageStore();
      if (this.userMode === 'shoot') {
        cell.state = HOVER_SHOOT;
      } else if (this.userMode === 'place') {
        if (this.shipOrientation === 'horizontal') {
          if (cell.col > GRID_SIZE - SHIP_LENGTH) {
            return;
          }
          cell.state = HOVER_PLACE;
          for (let i = cell.col + 1; i < cell.col + SHIP_LENGTH; i++) {
            this.getCell(cell.row, i).state = HOVER_PLACE;
          }
        } else {
          if (cell.row > GRID_SIZE - SHIP_LENGTH) {
            return;
          }
          cell.state = HOVER_PLACE;
          for (let i = cell.row + 1; i < cell.row + SHIP_LENGTH; i++) {
            this.getCell(i, cell.col).state = HOVER_PLACE;
          }
        }
      }
    },
    clearHover(event, cell) {
      for (let i = 0; i < this.cells.length; i++) {
        this.cells[i].state = NEUTRAL;
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
  min-width: 100%;
  padding: 1rem;
}

.game-controls {
  display: flex;
  flex-direction: row;
  gap: 8px;
}

.user-controls {
  width: 100%;
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
  width: 600px;
  height: 600px;
}

.cell {
  width: 100%; /* Each cell takes up 100% of the column width */
  padding-bottom: 20%; /* Padding to maintain aspect ratio */
  background-color: #eee; /* Default cell background color */
  border: 1px solid #ccc; /* Cell border */
  box-sizing: border-box;
  /*transition: background-color 0.3s; /* Smooth transition for background color */
}

.cell.highlight {
  background-color: orange; /* Cell background color on hover */
  cursor: pointer; /* Cursor changes to pointer on hover */
}
</style>
