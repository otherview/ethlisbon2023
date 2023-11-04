// useEventStore.js
import { defineStore } from 'pinia';
import { useContractStore } from "@/store/contractStore.js";

export const useEventStore = defineStore('events', {
    state: () => ({
        transactions: []
    }),

    actions: {
        async fetchTransactions() {
            const contractStore = useContractStore();

            // Access the contract instance from the contract store
            const contract = contractStore.getContract;

            // Assuming we want to listen for a specific event, here 'Transfer' is used as an example.
            // Make sure to replace 'Transfer' with the actual event you want to filter.
            // Additionally, the filter method should be called on the contract instance directly.
            const filter = contract.filters.PlayerShoots();

            // Query the filter for logs
            const logs = await contract.queryFilter(filter, 0, 'latest');

            logs.forEach(log => {
                console.log(log);
            });

            // Store the fetched transactions in state
            this.transactions = logs.map(log => log.args);
        }
    }
});
