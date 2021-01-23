import { useMemo } from 'react';
import { Box, Divider, Flex, Button, Tabs, Section, Checkbox, Dropdown } from '../components';
import { useBackend, useLocalState } from "../backend";
import { actOnCharacter as _actOnCharacter, characterName } from './helpers/characterSlotHelpers';

/* eslint-disable react/jsx-closing-tag-location */

/**
 * Returns the number of modifiable attributes for a given species.
 * Used to compute the layout of the selection table.
 */
const numModifiableSpeciesAttribs = species => {
  switch (species) {
    default: -1; // Flex layout and hope for the best.
  }
};

export const CharacterAppearancePanel = (props, context) => {
  const { act, data } = useBackend(context);

  const { species_define } = data;

  const { index, character } = props;

  const actOnCharacter = _actOnCharacter(act, { current: index });

  return (<Flex>
    <Flex.Item>
      <Section title="Body">
        <Flex.Item>
          <Button
            onClick={() => actOnCharacter('randomize_body')}
          >Random Body
          </Button>
        </Flex.Item>
        <Flex.Item>
          <Checkbox
            checked={character.always_random_body}
            onClick={() => actOnCharacter('toggle_random', { type: 'body' })}
          >Always Randomize Body
          </Checkbox>
        </Flex.Item>
        <Flex.Item>
          <Checkbox
            checked={character.always_random_antag_body}
            onClick={() => actOnCharacter('toggle_random', { type: 'body', antag: true })}
          >Always Randomize Antag Body
          </Checkbox>
        </Flex.Item>
      </Section>
    </Flex.Item>
    <Flex.Item>
      <Section title="Species">
        <Dropdown
          options={species_define.map(spec => spec.name)}

        />
      </Section>
    </Flex.Item>
  </Flex>);
};

export const CharacterAppearance = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    active_character,
  } = data;
  const {
    characters,
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

  return (<Box>
    <Tabs>
      {renderCharacterTabs()}
    </Tabs>
    <Divider />
    <Box>
      <CharacterAppearancePanel
        index={active_character}
        character={characters[active_character]} />
    </Box>
  </Box>);
};

export default CharacterAppearance;
