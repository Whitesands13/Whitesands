export const actOnCharacter = (act, slotRef) =>
  (action, payload) => act(action, { slot: slotRef.current, ...payload });

export default { actOnCharacter };
