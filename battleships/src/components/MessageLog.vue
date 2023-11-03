<template>
  <div class="message-log">
    <div v-for="(message, index) in reversedMessages"
         :key="message.id"
         :class="['message', getMessageClass(index)]">{{ message }}</div>
  </div>
</template>

<script>
import { computed } from 'vue';
import { useMessageStore } from '@/store/messageStore'

export default {
  name: 'MessageLog',
  setup() {
    const messageStore = useMessageStore()

    const reversedMessages = computed(() => {
      return [...messageStore.messages].reverse()
    })

    const getMessageClass = (index) => {
      if (index === 0) return 'first-message';
      if (index === 1) return 'second-message';
      return 'other-messages';
    }

    return {
      reversedMessages,
      getMessageClass
    }
  }
};
</script>

<style scoped>
.message-log {
  background-color: black;
  color: #00FF00;
  padding: 20px;
  border-radius: 5px;
  width: 100%;
  height: 200px;
  flex-grow: 1;
  overflow-y: auto;
  font-family: 'Courier New', Courier, monospace;
  box-shadow: inset 0 0 10px #00FF00;
}

@keyframes typing {
  from {
    width: 0;
  }
  to {
    width: 100%;
  }
}

.first-message {
  color: #00FF00;
  animation: typing 2s steps(25, end) 0s 1 normal both;
  overflow: hidden;
  white-space: nowrap;
}

.second-message {
  color: #49cc49;
  opacity: 0.8;
}

.other-messages {
  color: #3dab3d;
  opacity: 0.5;
}
</style>