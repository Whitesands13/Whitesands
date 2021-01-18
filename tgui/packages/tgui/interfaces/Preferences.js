import { useMemo } from 'react';
import { Button, Tabs } from '../components';
import { useBackend, useLocalState } from "../backend";
import { CharacterSetup } from './preferences';

export const Preferences = (props, context) => {
  const { act, data } = useBackend(context);

  const { characters, active_character } = data;

  const [activeTabIndex, setActiveTabIndex] = useLocalState(1);

  const tabUsesCharacterRender = index => index < 4;

  const PreferencesComponent = useMemo(() => {
    switch (activeTabIndex) {
      case 1:
        return <CharacterSetup {...props} />
      case 2:
        return <CharacterAppearance {...props} />
      case 3:
        return <GearSettings {...props} />
      case 4:
        return <GamePreferences {...props} />
      case 5:
        return <OOCPreferences {...props} />
      case 6:
        return <CustomKeybindings {...props} />
    }
  }, [activeTabIndex]);

  const CharacterRenderer = useMemo(() => {
    <CharacterRenderer character={characters[active_character]} />
  });

  return <React.Fragment>
    <Tabs>
      <Tabs.Tab
        selected={activeTabIndex === 1}
        onClick={() => setActiveTabIndex(1)}
      >Character Setup</Tabs.Tab>
      <Tabs.Tab
        selected={activeTabIndex === 2}
        onClick={() => setActiveTabIndex(2)}
      >Character Appearance</Tabs.Tab>
      <Tabs.Tab
        selected={activeTabIndex === 3}
        onClick={() => setActiveTabIndex(3)}
      >Gear</Tabs.Tab>
      <Tabs.Tab
        selected={activeTabIndex === 4}
        onClick={() => setActiveTabIndex(4)}
      >Game Preferences</Tabs.Tab>
      <Tabs.Tab
        selected={activeTabIndex === 5}
        onClick={() => setActiveTabIndex(5)}
      >OOC Preferences</Tabs.Tab>
      <Tabs.Tab
        selected={activeTabIndex === 6}
        onClick={() => setActiveTabIndex(6)}
      >Custom Key Bindings</Tabs.Tab>
    </Tabs>
    <Box>
      <Flex>
        <Flex.Item>
          {PreferencesComponent}
        </Flex.Item>
        {tabUsesCharacterRender(activeTabIndex) && <Flex.Item>
          {CharacterRender}
        </Flex.Item>}
      </Flex>
    </Box>
    <Box>
      <Button onClick={() => act('save')}>Save</Button>
      <Button onClick={() => act('cancel')}>Cancel</Button>
    </Box>
  </React.Fragment>;
};
