export const actOnCharacter = (act, slotRef) =>
  (action, payload) => act(action, { slot: slotRef.current, ...payload });

export const characterName = (slot, index) => {
  return slot ? slot.name : `Character Slot ${index}`;
};

export default { actOnCharacter, characterName };
