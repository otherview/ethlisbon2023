<template>
  <div>
    <connecting-splash v-if="!userConnected"></connecting-splash>
    <battleship-map v-else></battleship-map>
  </div>
</template>

<script>
import BattleshipMap from "@/components/BattleshipMap.vue";
import ConnectingSplash from "@/components/ConnectingSplash.vue";

export default {
  name: "Home",
  components: {ConnectingSplash, BattleshipMap},
  data() {
    return {
      userConnected: false,
    };
  },
}
</script>

<style scoped>

</style>