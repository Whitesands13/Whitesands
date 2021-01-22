import { useMemo } from 'react';
import { Flex, Button, Tabs } from '../components';
import { useBackend, useLocalState } from "../backend";
/**
 * Returns the number of modifiable attributes for a given species.
 * Used to compute the layout of the selection table.
 */
const numModifiableSpeciesAttribs = species => {
  switch (species) {
    default: -1; // Flex layout and hope for the best.
  };
};

export const CharacterAppearancePanel = (props, context) => {
  return;
};

export const CharacterAppearance = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    active_character
  } = data;
  const {
    characters
  } = data;

  const renderCharacterTabs = () => {
    let ret = [];
    for (let i = 0; i < characters.length; i++) {
      ret.push(
        <Tabs.Tab
          key={i}
          selected={active_character === i}
          onClick={() => act('set_active_character', { value: i })}
        >{characterName(characters[i], i)}</Tabs.Tab>
      );
    }
    return ret;
  };

  return <React.Fragment>
    <Tabs>
      {renderCharacterTabs()}
    </Tabs>
    <Divider />
    <Box>
      <CharacterAppearancePanel index={active_character} character={characters[activeTabIndex]} />
    </Box>
  </React.Fragment>;
};

export default CharacterAppearance;
