<template>
  <connecting-splash v-if="!userConnected"></connecting-splash>
  <battleship-map v-else></battleship-map>
</template>

<script>
import BattleshipMap from "@/components/BattleshipMap.vue";
import ConnectingSplash from "@/components/ConnectingSplash.vue";

export default {
  name: "Home",
  components: {ConnectingSplash, BattleshipMap},
  data() {
    return {
      userConnected: true,
    };
  },
}
</script>

<style scoped>

</style>