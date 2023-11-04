// messageStore.js
import { defineStore } from 'pinia';
import { ethers } from 'ethers';
import {useWalletStore} from "@/store/walletStore.js";
import {useMessageStore} from "@/store/messageStore.js";
import BattleshipJSON from "@/assets/contract/artifacts/contracts/Battleship.sol/Battleship.json";
import ContractAddress from "@/assets/contract/address.json";

export const useContractStore = defineStore('contract', {
    // State is a function that returns an object
    state: () => ({
        contract: null
    }),
    // Getters are like computed properties for stores
    getters: {

    },
    // Actions can be asynchronous and are where you define methods to change state
    actions: {
        async shoot(position, isVertical) {
            const walletStore = useWalletStore();
            const messageStore = useMessageStore();

            this.contract = new ethers.Contract(ContractAddress.address, BattleshipJSON.abi, walletStore.signer);

            if (!walletStore.connected()) {
                messageStore.addMessage("[Error] wallet not connected !");
                return;
            }

            try {
                messageStore.addMessage(`[Shoot] Shot ${position} - ${isVertical} !`);
                const tx = await this.contract.Shoot(position);
                const receipt = await tx.wait();
                console.log(receipt);
                if (receipt.events[0].args.hit) {
                    messageStore.addMessage(`[Shoot] Successfully hit XXXXXXXXX !`);
                } else {
                    messageStore.addMessage(`[Shoot] Didn't hit anything but sea !`);
                }


            }catch (e) {
                console.log(e)
            }
        }
    }
})
