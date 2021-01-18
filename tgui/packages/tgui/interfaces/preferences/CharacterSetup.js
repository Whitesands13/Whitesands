import { useBackend, useLocalState } from '../../backend';
import { Flex, NoticeBox, Tabs, Divider, Button, Input, Dropdown } from '../../components';
import OccupationPicker from './OccupationPicker';
import QuirkPicker from './QuirkPicker';

const genderDisplayNames = ['male', 'female', 'other'];

const characterName = (slot, index) => {
  return slot[i] ? slot[i].name : 'Character Slot 1';
};

export const CharacterSetupPanel = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    banned, flags, pref_defines
  } = data;

  const { index, character } = props;

  const actOnCharacter = (action, payload = {}) => act(action, { slot: index, ...payload })

  const renderCustomNamePreferences = () => {
    let ret = [];
    for (let i = 0; i < pref_defines.custom_names.length; i++) {
      const define = pref_defines.custom_names[i];
      const current = character.custom_name_prefs[define.type];
      ret.push(
        <Flex>
          <Flex.Item>
            <b>{define.type}:</b>&nbsp;{define.qdesc}
          </Flex.Item>
          <Flex.Item>
            <Input
              onChange={(e, value) => actOnCharacter('set_custom_name', {
                type: define.type, value
              })}
              value={current.value}
            />
          </Flex.Item>
        </Flex>
      );
    }
    return <Flex.Item>
      {ret}
    </Flex.Item>;
  };

  return <Flex>
    <Flex.Item>
      <OccupationPicker {...props} />
      <Divider />
    </Flex.Item>
    {flags.roundstart_traits && <Flex.Item>
      <QuirkPicker {...props} />
      <Divider />
    </Flex.Item>}
    {banned.appearance && <Flex.Item>
      <NoticeBox danger={true}>
        <b>
          You are banned from using custom names and appearances.
          You can continue to adjust your characters, but you will be randomised once you join the game.
        </b>
      </NoticeBox>
    </Flex.Item>}
    <Flex.Item>
      <Button
        onClick={() => actOnCharacter('randomize_name')}
      >Random Name</Button>
      <Button.Checkbox
        checked={character.always_random_name}
        onClick={() => actOnCharacter('toggle_random', { type: 'name' })}
      >Always Random Name</Button.Checkbox>
      <Button.Checkbox
        checked={character.always_random_antag_name}
        onClick={() => actOnCharacter('toggle_random', { type: 'name', antag: true })}
      >Always Random Antag Name</Button.Checkbox>
    </Flex.Item>
    <Flex.Item>
      Name: <Input
        value={character.real_name}
        onChange={(evt, value) => actOnCharacter('update_real_name', { value })}
      />
    </Flex.Item>
    {!character.species.traits.agender && <Flex.Item>
      Gender: <Dropdown
        options={genderDisplayNames}
        selected={genderDisplayNames[character.gender]}
        onSelected={value => actOnCharacter('select_gender', { value: genderDisplayNames.indexOf(value) })}
      />
    </Flex.Item>}
    {character.always_random_body || character.always_random_antag_body && <Flex.Item>
      <Button.Checkbox
        checked={character.always_random_gender}
        onClick={() => actOnCharacter('toggle_random', { type: 'gender' })}
      >Always Random Gender</Button.Checkbox>
      <Button.Checkbox
        checked={character.always_random_antag_gender}
        onClick={() => actOnCharacter('toggle_random', { type: 'gender', antag: true })}
      >Always Random Antag Gender</Button.Checkbox>
    </Flex.Item>}
    <Flex.Item>
      Age: <Input
        value={character.age}
        onChange={(evt, value) => {
          const san_val = parseInt(value);
          if (Number.isNaN(san_val)) {
            actOnCharacter('update_age', {value: character.age })
          } else {
            actOnCharacter('update_age', { value: sand_val })
          }
        }}
      />
    </Flex.Item>
    {character.always_random_body || character.always_random_antag_body && <Flex.Item>
      <Button.Checkbox
        checked={character.always_random_age}
        onClick={() => actOnCharacter('toggle_random', { type: 'age' })}
      >Always Random Age</Button.Checkbox>
      <Button.Checkbox
        checked={character.always_random_antag_age}
        onClick={() => actOnCharacter('toggle_random', { type: 'age', antag: true })}
      >Always Random Antag Age</Button.Checkbox>
    </Flex.Item>}
    <Flex.Item>
      Flavor Text:<br/>
      <TextArea
        value={character.flavor_text}
        onChange={(evt, value) => actOnCharacter('update_flavor_text', { value })}
      />
    </Flex.Item>
    <Flex.Item>
      <Divider />
      <b>Special Names</b>
    </Flex.Item>
    {renderCustomNamePreferences()}
    <Flex.Item>
      <Divider />
      <b>Custom Job Preferences</b>
    </Flex.Item>
    <Flex.Item>
      AI Core Display Options: <Dropdown
        options={pref_defines.ai_core_display}
        selected={character.ai_core_display}
        onSelected={value => actOnCharacter('set_ai_core_display', { value })}
      />
    </Flex.Item>
    <Flex.Item>
      Preferred Security Department: <Dropdown
        options={pref_defines.sec_department}
        onSelected={value => actOnCharacter('set_pref_sec_department', { value })}
      />
    </Flex.Item>
    <Flex.Item>
      <Divider />
      <b>Clothing</b>
    </Flex.Item>
    <Flex.Item>
      Backpack: <Dropdown
        options={pref_defines.backpack_types}
        selected={character.bag}
        onSelected={value => actOnCharacter('set_bag_type', { value })}
      />
    </Flex.Item>
    <Flex.Item>
      Jumpsuit Style: <Dropdown
        options={pref_defines.jumpsuit_styles}
        selected={character.suit}
        onSelected={value => actOnCharacter('set_suit_type', { value })}
      />
    </Flex.Item>
    <Flex.Item>
      Outerwear Style: <Dropdown
        options={pref_defines.outerwear_styles}
        selected={character.exo}
        onSelected={value => actOnCharacter('set_exo_type', { value })}
      />
    </Flex.Item>
    <Flex.Item>
      Uplink Spawn Location: <Dropdown
        options={pref_defines.uplink_locations}
        selected={character.uplink_loc}
        onSelected={value => actOnCharacter('set_uplink_loc', { value })}
      />
    </Flex.Item>
  </Flex>
};

export const CharacterSetup = (props, context) => {
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
    <Box>
      <CharacterSetupPanel index={active_character} character={characters[activeTabIndex]} />
    </Box>
  </React.Fragment>;
};

export default CharacterSetup;
